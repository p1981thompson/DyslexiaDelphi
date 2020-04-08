likert.density.plot3<-function (likert, facet = TRUE, bw = 0.5, legend, ...) 
{
  lsum <- summary(likert)
  items <- likert$items
  items.density <- data.frame()
  labels <- label_wrap_mod3(paste0(levels(items[, 1]), " (", 
                                  1:likert$nlevels, ")"), width = 100)
  if (is.null(likert$grouping)) {
    for (l in seq_along(items)) {
      suppressWarnings({
        den <- density(as.integer(items[, l]), bw = bw, 
                       na.rm = TRUE, ...)
      })
      items.density <- rbind(items.density, data.frame(Item = names(items)[l], 
                                                       x = den$x, y = den$y))
    }
    p <- ggplot(items.density, aes(x = x, y = y, color = Item, 
                                   fill = Item, group = Item)) + geom_polygon(alpha = 0.05) + 
      geom_path() + scale_x_continuous(breaks = 1:likert$nlevels, 
                                       labels = labels,limits=c(-0.5,6)) + xlab("") + ylab("") + theme(axis.text.y = element_blank(), 
                                                                                      axis.ticks.y = element_blank(), axis.text.x = element_text(angle = 30, hjust = 1))
    if (facet) {
      p <- p + facet_wrap(~Item, ncol = 1) + theme(legend.position = "none")
    }
  }
  else {
    groups <- likert$grouping
    for (g in unique(groups)) {
      items.g <- items[groups == g, ]
      for (l in seq_along(items)) {
        suppressWarnings({
          den <- density(as.integer(items.g[, l]), bw = bw, 
                         na.rm = TRUE, ...)
        })
        items.density <- rbind(items.density, data.frame(Item = names(items)[l], 
                                                         Group = g, x = den$x, y = den$y))
      }
    }
    p <- ggplot(items.density, aes(x = x, y = y, color = Group, 
                                   fill = Group, group = Group)) + geom_polygon(alpha = 0.05) + 
      geom_path() + facet_wrap(~Item, ncol = 1) + scale_x_continuous(breaks = 1:likert$nlevels, 
                                                                     labels = labels,limits=c(-0.5,6)) + xlab("") + ylab("") + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.text.x = element_text(angle = 30, hjust = 1))
  }
  if (!missing(legend)) {
    p <- p + labs(fill = legend, color = legend)
  }
  return(p)
}

label_wrap_mod3<-function (value, width = 100) 
{
  sapply(strwrap(as.character(value), width = width, simplify = FALSE), 
         paste, collapse = "\n")
}
