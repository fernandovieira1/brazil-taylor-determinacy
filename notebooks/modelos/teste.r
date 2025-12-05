# install.packages("testthat")
#library(testthat)
# install.packages("tidyverse")
library(tidyverse)
# Script de teste para R no VS Code
# Pressione Ctrl+Enter para executar linha por linha

# Carregar bibliotecas (instale se necessário)
# install.packages("ggplot2")
library(ggplot2)

# Criar dados de exemplo
set.seed(42)
dados <- data.frame(
  x = 1:100,
  y = cumsum(rnorm(100, mean = 0.5, sd = 2)),
  categoria = rep(c("A", "B", "C", "D"), 25)
)

# Plot 1: Gráfico de linha simples
plot(dados$x, dados$y, 
     type = "l", 
     col = "blue", 
     lwd = 2,
     main = "Série Temporal Aleatória",
     xlab = "Tempo",
     ylab = "Valor")
grid()

# Plot 2: Scatter plot com cores
plot(dados$x, dados$y, 
     col = as.factor(dados$categoria),
     pch = 19,
     main = "Scatter Plot por Categoria",
     xlab = "X",
     ylab = "Y")
legend("topleft", 
       legend = levels(as.factor(dados$categoria)),
       col = 1:4,
       pch = 19)

# Plot 3: Usando ggplot2 (mais bonito)
ggplot(dados, aes(x = x, y = y, color = categoria)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = "Visualização com ggplot2",
    subtitle = "Séries por categoria",
    x = "Índice",
    y = "Valor Acumulado",
    color = "Categoria"
  ) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    legend.position = "bottom"
  )

# Plot 4: Histograma
hist(dados$y, 
     col = "lightblue",
     border = "white",
     main = "Distribuição dos Valores",
     xlab = "Valor",
     ylab = "Frequência",
     breaks = 20)

# Plot 5: Boxplot por categoria
boxplot(y ~ categoria, 
        data = dados,
        col = c("coral", "lightgreen", "lightblue", "plum"),
        main = "Boxplot por Categoria",
        xlab = "Categoria",
        ylab = "Valor")

# Visualizar dados no painel de variáveis
print(head(dados))
print(summary(dados))


library(tidyverse)
set.seed(42)
dados <- data.frame(
  x = 1:100,
  y = cumsum(rnorm(100, mean = 0.5, sd = 2)),
  categoria = rep(c("A", "B", "C", "D"), 25)
)

