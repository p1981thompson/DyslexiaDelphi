
label.wrap.mod2<-function(value, width = 25) 
{
  sapply(strwrap(as.character(value), width = width, simplify = FALSE), 
         paste, collapse = "\n")
}


likert.histogram.plot2<-function (l, xlab = "N", plot.missing = TRUE, bar.color = "grey70", 
          missing.bar.color = "dark blue", label.completed = "Rated", 
          label.missing = "Not sure\nNo opinion", legend.position = "bottom", wrap = ifelse(is.null(l$grouping), 
                                                                               50, 100), order, group.order, panel.arrange = "v", panel.strip.color = "#F0F0F0", 
          text.size = 3.5, ...) 
{
   
  nacount <- function(items) {
    if (ncol(items) == 1) {
      tab <- table(is.na(items[, 1]))
      hist <- data.frame(missing = c(FALSE, TRUE), Item = rep(names(items)[1], 
                                                              2), value = unname(c(tab["FALSE"], tab["TRUE"])))
      if (length(which(is.na(hist$value))) > 0) {
        hist[is.na(hist$value), ]$value <- 0
      }
      row.names(hist) <- 1:nrow(hist)
      hist[hist$missing, ]$value <- -1 * hist[hist$missing, 
                                              ]$value
      return(hist)
    }
    else {
      hist <- as.data.frame(sapply(items, function(x) {
        table(factor(is.na(x), levels = c(TRUE, FALSE)))
      }), stringsAsFactors = FALSE)
      hist$missing <- row.names(hist)
      hist <- reshape::melt.data.frame(hist, id.vars = "missing", 
                                       variable_name = "Item")
      hist$missing <- as.logical(hist$missing)
      hist[hist$missing, ]$value <- -1 * hist[hist$missing, 
                                              ]$value
      return(hist)
    }
  }
  items <- l$items
  if (missing(order)) {
    order <- names(items)
  }
  if (is.null(l$grouping)) {
    hist <- nacount(items)
    hist$Item <- label_wrap_mod2(hist$Item, width = wrap)
    hist$Item <- factor(hist$Item, levels = label_wrap_mod2(order, 
                                                           width = wrap), ordered = TRUE)
    p <- ggplot(hist, aes(x = Item, y = value, fill = missing, 
                          label = value))
    if (plot.missing) {
      p <- p + geom_bar(data = hist[hist$missing, ], stat = "identity")
    }
    p <- p + geom_bar(data = hist[!hist$missing, ], stat = "identity") + 
      geom_hline(yintercept = 0) + geom_text(data = hist[hist$missing, 
                                                         ], hjust = -2, size = text.size,colour="white") + scale_y_continuous(label = abs_formatter) + 
      coord_flip() + ylab(xlab) + xlab("") + theme(legend.position = legend.position) + 
      scale_fill_manual("", limits = c(TRUE, FALSE), labels = c(label.missing, 
                                                                label.completed), values = c(missing.bar.color, 
                                                                                             bar.color))
  }
  else {
    hist <- data.frame()
    for (g in unique(l$grouping)) {
      tmp <- items[l$grouping == g, , drop = FALSE]
      h <- nacount(tmp)
      h$group <- g
      hist <- rbind(hist, h)
    }
    hist$Item <- label_wrap_mod2(hist$Item, width = wrap)
    hist$Item <- factor(hist$Item, levels = label_wrap_mod2(order, 
                                                           width = wrap), ordered = TRUE)
    p <- ggplot(hist, aes(x = group, y = value, fill = missing, 
                          label = value))
    if (plot.missing) {
      p <- p + geom_bar(data = hist[hist$missing, ], stat = "identity")
    }
    p <- p + geom_bar(data = hist[!hist$missing, ], stat = "identity") + 
      geom_hline(yintercept = 0) + geom_text(data = hist[hist$missing, ], hjust = -2, size = text.size,colour="white")
    + scale_y_continuous(label = abs_formatter) + 
      coord_flip() + ylab(xlab) + xlab("") + scale_fill_manual("", 
                                                               limits = c(TRUE, FALSE), labels = c(label.missing, 
                                                                                                   label.completed), values = c(missing.bar.color, 
                                                                                                                                bar.color)) + theme(legend.position = legend.position, 
                                                                                                                                                    axis.ticks = element_blank(), strip.background = element_rect(fill = panel.strip.color, 
                                                                                                                                                                                                                  color = panel.strip.color))
    if (is.null(panel.arrange)) {
      p <- p + facet_wrap(~Item)
    }
    else if (panel.arrange == "v") {
      p <- p + facet_wrap(~Item, ncol = 1)
    }
    else if (panel.arrange == "h") {
      p <- p + facet_wrap(~Item, nrow = 1)
    }
    if (!missing(group.order)) {
      p <- p + scale_x_discrete(limits = rev(group.order))
    }
  }
  class(p) <- c("likert.bar.plot", class(p))
  return(p)
}
