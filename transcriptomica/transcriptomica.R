################################################################################

################################ GSVA ##########################################

################################################################################

setwd("C:/Users/DELL/OneDrive/Documentos/datasets")
bd <- read.csv("bd.csv", row.names = 1)
View(bd)      # chequeo
dim(bd)       # dimensiones

# conseguir gene set de go
gsva_df <- msigdbr(species = "Homo sapiens", category = "C5")

# conseguir gene set de kegg
gsva_df <- msigdbr(
  species = "Homo sapiens",
  collection = "C2",
  subcollection = "CP:KEGG_MEDICUS")

# conseguir gene sets Hallmark
gsva_df <- msigdbr(
  species = "Homo sapiens",
  collection = "H")

# transformar el set a lista para poder trabajar con GSVA
gsva_list <- gsva_df %>% split(x = .$gene_symbol, f = .$gs_name)
class(gsva_list)

# genes en comun (son los unicos relevantes)
common_genes <- intersect(        # cantidad de genes en comun
  rownames(bd), unique(unlist(gsva_list)))
length(common_genes)              # norec: go: 13788 /kegg: 2441/hall: 3943 // rec: go: /kegg: 2441 / hall: 3943
bd_filtrada <- bd[common_genes, ] # dejar solo los genes en comun
View(bd_filtrada)                 # no rec: go: 13788 / rec: kegg: 2441 x 27 / hall: 3942 x 27

# eliminar genes duplicados del kegg list
gsva_unique <- lapply(gsva_list, unique)

# opcion mas simple sin todo el quilombo (me maté)
param <- gsvaParam(
  expr = bd_filtrada,
  geneSets = gsva_unique,
  minSize = 10,
  maxSize = 500
)
gsva <-gsva(param)
View(gsva)

# GUARDAR GSVA
setwd("C:/Users/DELL/OneDrive/Documentos/datasets")
write.csv(gsva,"gsva.csv",row.names = TRUE)

# PHEATMAP BASICO
gsva_matrix <- as.matrix(gsva)
View(gsva_matrix)
pheatmap(
  gsva_matrix,
  scale = "row",
  show_rownames = FALSE)

################################################################################

################################## LIMMA #######################################

################################################################################

# obtener datos clinicos
setwd("C:/Users/DELL/OneDrive/Documentos/datasets")
gsva<- read.csv("gsva.csv", row.names = 1)
cli <- read.csv("datos_clinicos.csv", row.names = 1)
View(gsva)

# chequeo que todas las bases tengas los mismos pacientes y ordenados
nrow(cli)             # cantidad de pacientes 
table(cli$recurrence) # comparación de variable clinica
dim(gsva)             # dimensiones
all(colnames(gsva) == cli$geo_accession) # chequear que esten en el mismo orden

# genero variable categorica
group <- factor(cli$recurrence)
table(group)
design <- model.matrix(~ group)
design
dim(design)

# modelo lineal (gsva score = promedio + efecto de relapse para cada pathway)
fit <- lmFit(gsva,design) # coeficientes, errores, var, estadisticas.
fit <- eBayes(fit)        # resultados mas confiables
results <- topTable(fit, coef = 2, number = Inf)
head(results)
sum(results$P.Value < 0.05)
sum(results$adj.P.Val < 0.05)
View(results)
write.csv(results, "limma.csv", row.names = TRUE)

# gráficos

plot(
  limma$logFC,
  -log10(limma$P.Value),
  pch = 16,
  xlab = "logFC",
  ylab = "-log10(p-value)")

hist(
  limma$P.Value,
  breaks = 50,
  main = "Distribution of p-values",
  xlab = "p-value")

# volcano plot por color con nombre para los singificativos
limma$Significant <- "Not significant"
limma$Significant[limma$P.Value < 0.05 & limma$logFC > 0] <- "Up"
limma$Significant[limma$P.Value < 0.05 & limma$logFC < 0] <- "Down"
limma$Pathway <- rownames(limma)
ggplot(limma, aes(x = logFC, y = -log10(P.Value))) +
  geom_point(aes(color = Significant), size = 2) +
  scale_color_manual(
    values = c(
      "Up" = "red",
      "Down" = "blue",
      "Not significant" = "grey")) +
  geom_hline(
    yintercept = -log10(0.05),
    linetype = "dashed") +
  geom_text_repel(data = subset(limma, P.Value < 0.05),aes(label = Pathway),size = 3) +
  labs(
    title = "Volcano plot",
    x = "logFC",
    y = "-log10(p-value)" ) +  theme_minimal()

table(limma$Significant)

################################################################################

#################################### GSEA  #####################################

################################################################################
setwd("C:/Users/DELL/OneDrive/Documentos/datasets")
results <- read.csv("limmas.csv", row.names = 1)
View(results)

# geneList debe estar ordenado de mayor a menor
geneList <- results$logFC
names(geneList) <- rownames(results)
View(geneList)

# Ordenar el vector
geneList <- sort(geneList, decreasing = TRUE)

# Ejecutar GSEA
gsea_result <- gseGO(
  geneList = geneList,
  OrgDb = org.Hs.eg.db,
  ont = "BP",
  keyType = "SYMBOL",
  nPerm = 10000, 
  minGSSize = 5, 
  maxGSSize = 800,
  pvalueCutoff = 0.05,
  verbose = TRUE)

# Ver resultados
head(gsea_result)
View(gsea_result)
View(gsea_result@result)
min(gsea_result@result$setSize)

setwd("C:/Users/DELL/OneDrive/Documentos/datasets")
write.csv(gsea_result@result,"gsea_result.csv",row.names = TRUE)

# Graficar un pathway
gseaplot2(gsea_result,geneSetID = 1)
class(gsea_result)
length(gsea_result)
require(DOSE)

dotplot(gsea_result, showCategory=10, split=".sign") + facet_grid(.~.sign)
ridgeplot(gsea_result) + labs(x = "enrichment distribution")

ridgeplot(
  gsea_result,
  showCategory = 15,      # número de pathways a mostrar
  fill = "pvalue") +
  labs(
    x = "Enrichment distribution",
    y = "Pathways",
    title = "Distribution of gene set enrichment scores") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.y = element_text(size = 9))


