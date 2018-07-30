
## gganimate example

# summary fx
qn <- function(x, d = 3) round(quantile(x, c(0.5, 0.025, 0.975)), d)

# read original data
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

# define the main descriptive data set
dt <- dplyr::select(d, "sti.trate.all", "race.cat", "age",
                    "hiv", "cuml.pnum", "city2")
dt <- dt[complete.cases(dt), ]


fit <- readRDS("data/f1.fit3.rda")

# city specific
df.city <- as.data.frame(fit, par = "a")
df.hiv <- as.data.frame(fit, par = "beta")
df.int <- as.data.frame(fit, par = "theta")

# HIV-
df0 <- exp(df.city - log(2))
names(df0) <- levels(as.factor(dt$city2))

# HIV+
df1 <- df0
for (i in 1:ncol(df1)) {
  df1[, i] <- exp(df.city[, i] - log(2) + df.hiv + df.int[, i])
}
names(df1) <- levels(dt$city2)

df0 <- select(df0, -starts_with("z"))
df1 <- select(df1, -starts_with("z"))

df0$HIV <- "HIV-uninfected"
df1$HIV <- "HIV-infected"

head(df0)
head(df1)

df <- rbind(df0, df1)
table(df$HIV)

dfg <- gather(df, key = "city", value = "coef", -HIV)
head(dfg)
dfg$city[which(dfg$city == "New York City")] <- "NYC"
dfg$city[which(dfg$city == "Philadelphia")] <- "Philly"
dfg$city[which(dfg$city == "San Diego")] <- "SD"
dfg$city[which(dfg$city == "San Francisco")] <- "SF"
dfg$city[which(dfg$city == "Los Angeles")] <- "LA"

table(dfg$HIV, dfg$city)

ggplot(dfg, aes(x = city, y = coef, fill = HIV), alpha = 0.5) +
  geom_boxplot(outlier.alpha = 0, fatten = 0.7, lwd = 0.4, col = "grey10") +
  scale_y_continuous(limits = c(0, 3.0)) +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "City", y = "Rate") +
  theme_bw()


library("gganimate")
library("RColorBrewer")
pal <- brewer.pal(3, "Set1")
dfg$HIV_color <- ifelse(dfg$HIV == "HIV-infected", pal[1], pal[2])
table(dfg$HIV, dfg$HIV_color)

dfg$HIV <- as.factor(dfg$HIV)


ggplot(dfg, aes(x = city, y = coef), alpha = 0.5) +
  geom_boxplot(outlier.alpha = 0, fatten = 0.7, lwd = 0.4, col = "grey10", fill = pal[2]) +
  transition_states(HIV, transition_length = 2, state_length = 1) +
  scale_y_continuous(limits = c(0, 3.0)) +
  labs(title = "Asymptomatic Bacterial STI Screening Rates by City, {closest_state}",
       x = "City", y = "Rate") +
  theme_bw()

