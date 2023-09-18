### Gwenna Breton
### 20200429
### Goal: replot MOSAIC results from 20200421 run, when the length of the population names prevented proper identification.
### I will also replot the results from 20200425 - see below.

#setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/MOSAIC/20200421")
require(MOSAIC)

#Plot of mu
#The top two bars are not shown. This is misleading! Increasing the size of the pdf does not make a difference.
#ord.Mu <- plot_Mu(Mu,alpha,NL)

#Mu is a matrix with 40 rows (number of sources) and three columns (number of ancestries).
#alpha is a list of list (?) with 33 vectors of length 3 - this might be for each of the individuals in the target population.
#NL has length 41.
#I have the feeling that it will be difficult to modify the plots. But I could at least look at the various entries and figure out what the top contributors are.
#ord.Mu is a list with three vectors; each vector is one of the three components; the populations are ordered by increasing contribution.

# plot_Mu(Mu,alpha,NL,showgradient = TRUE) #here all the populations are shown, but the names are cut off! This is frustrating. mar does not seem to be the right parameter to change...
# 
# plot_Mu(Mu,alpha,NL,MODE="copy") #not sure what this is for! The default mode is "scaled".
# 
# plot_Mu(Mu,alpha,NL,beside=FALSE) #this is not great but at least the population names are readable and all populations are included.

## In the end I decided to modify the function itself and it worked.

plot_Mu_Gwenna <- function (t.Mu, t.alpha, t.NL, MODE = "scaled", showgradient = FALSE, 
          beside = TRUE, ord = TRUE, pow = 1, cexa = 1.5, shiftl = ifelse(showgradient, 
                                                                          0, max(sapply(rownames(t.Mu), nchar))/2 * cexa), shiftt = ifelse(!showgradient, 
                                                                                                                                           cexa, cexa * 2), cutoff = 0, tol = 1e-06, colvec = c("#E69F00", 
                                                                                                                                                                                                "#56B4E9", "#009E73", "#CC79A7", "#D55E00", "#F0E442", 
                                                                                                                                                                                                "#0072B2", "#999999")) 
{
  t.kLL = nrow(t.Mu)
  t.alpha = Reduce("+", t.alpha)/length(t.alpha)
  if (MODE == "copy") 
    t.Mu = t.Mu
  if (MODE == "scaled" | MODE == "jointscaled") {
    t.Mu = t.Mu/t.NL[1:t.kLL]
    t.Mu = t(t(t.Mu)/colSums(t.Mu))
  }
  if (MODE == "joint" | MODE == "jointscaled") 
    t.Mu = t(t(t.Mu) * t.alpha)
  A = ncol(t.Mu)
  par(mar = c(3, 1 + shiftl, 1 + shiftt, 1), bty = "n", cex.axis = cexa, 
      cex.lab = cexa, cex.main = cexa)
  t.Mu[t.Mu < tol] <- tol
  if (ord) {
    vord <- NULL
    for (l in 1:A) {
      maxforthis <- which(apply(t.Mu, 1, which.max) == 
                            l)
      vord <- c(vord, maxforthis[sort(t.Mu[maxforthis, 
                                           l], index = TRUE)$ix])
    }
    t.Mu <- as.matrix(t.Mu[vord, ])
  }
  if (!beside) {
    tmp = rep(FALSE, nrow(t.Mu))
    for (l in 1:A) tmp = (tmp | (t.Mu[, l] >= quantile(t.Mu[, 
                                                            l], cutoff)))
    t.Mu = t.Mu[tmp, ]
  }
  if (!showgradient & !beside) {
    barplot(t(t.Mu), space = FALSE, col = colvec, horiz = TRUE, 
            las = TRUE, cex.axis = cexa, cex.names = cexa)
    for (i in 1:A) text(x = (i) * 0.2 * max(rowSums(t.Mu)), 
                        y = 0.5 + 1.2 * (nrow(Mu) + 1), round(t.alpha[i], 
                                                              3), cex = cexa, col = colvec[i])
  }
  if (!showgradient & beside) {
    if (ord) 
      par(mfrow = c(1, A))
    par(mar = c(3, 1 + shiftl, 1 + shiftt, 1), bty = "n", 
        cex.axis = cexa, cex.lab = cexa, cex.main = cexa)
    if (!ord) {
      nf <- layout(matrix(c(1:(A + 1)), ncol = A + 1), 
                   widths = c(1, rep(2, A)), TRUE)
      plot(c(-cexa * 2, ncol(t.Mu)), c(1, nrow(t.Mu) + 
                                         shiftt), t = "n", yaxt = "n", xaxt = "n", main = "", 
           xlab = "", ylab = "")
      text(x = cexa * 2, pos = 2, y = 0.5 + 1.2 * (1:nrow(t.Mu)), 
           rownames(t.Mu), cex = 1.75 * cexa)
    }
    if (ord) {
      allord = apply(t.Mu, 2, order)
      ordMu = NULL
      for (a in 1:A) ordMu[[a]] = t.Mu[allord[, a], a]
    }
    else {
      ordMu = NULL
      for (a in 1:A) ordMu[[a]] = t.Mu[, a]
    }
    if (cutoff > 0) {
      for (a in 1:A) ordMu[[a]] = ordMu[[a]][ordMu[[a]] >= 
                                               quantile(ordMu[[a]], cutoff)]
    }
    xmax = max(unlist(ordMu))
    for (a in 1:A) {
      tmpMu = c(ordMu[[a]], NaN)
      names(tmpMu)[length(ordMu[[a]]) + 1] = round(t.alpha[a], 
                                                   3)
      if (ord) 
        y = barplot(tmpMu, horiz = TRUE, las = 1, col = colvec[a], 
                    xlim = c(0, xmax), ylim = c(0, 5 + length(tmpMu)), #modified ylim. I do not know what the numbers which appear on the top are (might be average contribution of each component).
                    cex.names = cexa, cex.axis = cexa, main = "", 
                    cex.main = cexa * 2)
      if (!ord) 
        y = barplot(tmpMu, horiz = TRUE, las = 1, col = colvec[a], 
                    xlim = c(0, xmax), cex.names = cexa, cex.axis = cexa, 
                    main = "", ylim = c(0, 1 + length(tmpMu)), 
                    cex.main = cexa * 2, names.arg = rep("", length(tmpMu)))
    }
  }
  if (showgradient) {
    alpha.Mu <- t.Mu^pow
    alpha.Mu <- t(t(alpha.Mu)/apply(alpha.Mu, 2, max))
    plot(c(-shiftl, ncol(t.Mu)), c(0.5, nrow(t.Mu) + 0.5), 
         t = "n", yaxt = "n", xaxt = "n", main = "", xlab = "", 
         ylab = "")
    mtext(side = 3, at = 1:A - 0.5, round(t.alpha, 3), cex = cexa)
    for (l in 1:ncol(t.Mu)) for (ll in 1:nrow(t.Mu)) {
      tmprgb = rgb(t(col2rgb(colvec[l])/255), alpha = alpha.Mu[ll, 
                                                               l])
      polygon(x = c(l, l + 1, l + 1, l) - 1, y = c(ll, 
                                                   ll, ll + 1, ll + 1) - 0.5, col = tmprgb, border = NA)
    }
    text(x = 0, pos = 2, y = (1:nrow(t.Mu)), rownames(t.Mu), 
         cex = 0.75 * cexa)
  }
  if (showgradient) 
    return(NULL)
  if (ord) 
    if (!beside) 
      return(t.Mu)
  if (beside) 
    return(ordMu)
}

#FST

#argument ord: order from largest 1-Fst to smallest
#argument reverse=TRUE: show 1-Fst instead of Fst (if it would show Fst, the largest the fraction would mean the furthest apart).

plot_Fst_Gwenna <- function (t.Fst, ord = TRUE, cexa = 1, shiftl = cexa, shiftt = cexa, 
          cutoff = nrow(t.Fst), reverse = TRUE, colvec = c("#E69F00", 
                                                           "#56B4E9", "#009E73", "#CC79A7", "#D55E00", "#F0E442", 
                                                           "#0072B2", "#999999")) 
{
  t.kLL = nrow(t.Fst)
  if ((!ord) & (cutoff != t.kLL)) {
    warning("########## showing all as re-ordering not allowed ##########", 
            immediate. = T)
    cutoff = t.kLL
  }
  if (cutoff > t.kLL) 
    cutoff = t.kLL
  A = ncol(t.Fst)
  par(mar = c(6, 8 + shiftl, 1 + shiftt, 1), bty = "n", cex.axis = cexa, #modified that (initial: 4 for the left margin).
      cex.lab = cexa, cex.main = cexa)
  if (ord) 
    par(mfrow = c(1, A))
  if (!ord) {
    par(mar = c(6, 2, 1 + shiftt, 1), bty = "n", cex.axis = cexa, 
        cex.lab = cexa, cex.main = cexa)
    nf <- layout(matrix(c(1:(A + 1)), ncol = A + 1), widths = c(1, 
                                                                rep(2, A)), TRUE)
    plot(c(-cexa, ncol(t.Fst)), c(0.5, nrow(t.Fst) + 0.5), 
         t = "n", yaxt = "n", xaxt = "n", main = "", xlab = "", 
         ylab = "")
    text(x = 2, pos = 2, y = (1:nrow(t.Fst)), rownames(t.Fst), 
         cex = cexa)
  }
  if (ord) {
    allord = apply(t.Fst, 2, order, decreasing = TRUE)
    ordFst = NULL
    for (a in 1:A) ordFst[[a]] = t.Fst[allord[, a], a]
  }
  else {
    ordFst = NULL
    for (a in 1:A) ordFst[[a]] = t.Fst[, a]
  }
  rangeFst = NULL
  for (a in 1:A) {
    ordFst[[a]] = tail(ordFst[[a]], cutoff)
    if (reverse) 
      rangeFst[[a]] = range(1 - ordFst[[a]])
    if (!reverse) 
      rangeFst[[a]] = range(ordFst[[a]])
  }
  for (a in 1:A) {
    if (ord) {
      if (reverse) 
        plot(c(0, 1), c(0, cutoff + 6), t = "n", yaxt = "n", # modified the y component (cutoff+1 to cutoff+6)
             ylab = "", xlab = "1-Fst", cex.main = cexa, 
             main = "", cex.axis = cexa, xlim = c(rangeFst[[a]][1], 
                                                  rangeFst[[a]][2]))
      if (!reverse) 
        plot(c(0, 1), c(0, cutoff + 1), t = "n", yaxt = "n", 
             ylab = "", xlab = "Fst", cex.main = cexa, main = "", 
             cex.axis = cexa, xlim = c(0, rangeFst[[a]][2]))
      if (reverse) {
        tmp = 1 - ordFst[[a]] - rangeFst[[a]][1]
        y = barplot(tmp, horiz = TRUE, las = 1, col = colvec[a], 
                    cex.names = cexa, cex.axis = cexa, main = "", 
                    cex.main = cexa, add = T, offset = rangeFst[[a]][1])
      }
      if (!reverse) 
        y = barplot(ordFst[[a]], horiz = TRUE, las = 1, 
                    col = colvec[a], cex.names = cexa, cex.axis = cexa, 
                    main = "", cex.main = cexa, add = T)
    }
    if (!ord & reverse) 
      y = barplot(1 - ordFst[[a]] - rangeFst[[a]][1], horiz = TRUE, 
                  las = 1, col = colvec[a], cex.names = cexa, cex.axis = cexa, 
                  main = "", xlab = "1-Fst", cex.main = cexa, names.arg = rep("", 
                                                                              length(ordFst[[a]])), offset = rangeFst[[a]][1])
    if (!ord & !reverse) 
      y = barplot(ordFst[[a]], horiz = TRUE, las = 1, col = colvec[a], 
                  cex.names = cexa, cex.axis = cexa, main = "", 
                  xlab = "Fst", cex.main = cexa, names.arg = rep("", 
                                                                 length(ordFst[[a]])))
  }
  if (ord) 
    return(ordFst)
}


# #20200421 runs
# #for (prefix in c("Bangweulu_Zambia_3way_1-36","Bemba_Zambia_3way_1-13","Kafue_Zambia_3way_1-33","Lozi_Zambia_3way_1-25","Tonga_Zambia_3way_1-9")) {
# for (prefix in c("Bangweulu_Zambia_4way_1-36","Bemba_Zambia_4way_1-13","Kafue_Zambia_4way_1-33","Lozi_Zambia_4way_1-25","Tonga_Zambia_4way_1-9")) {
#   load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1956_60_0.99_100.RData",sep="")) #model parameters
#   load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1956_60_0.99_100.RData",sep="")) #local ancestry
#   pdf (file=paste(prefix,"_1-22_1956_60_0.99_100_mu_new.pdf"), width =30, height = 15, pointsize =15)
#   plot_Mu_Gwenna(Mu,alpha,NL)
#   dev.off()
#   pdf (file=paste(prefix,"_1-22_1956_60_0.99_100_Fst_new.pdf"), width =30, height = 15, pointsize =15)
#   plot_Fst_Gwenna(all_Fst$panels,ord=T)
#   dev.off()
# }

#20200425 runs
# setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/MOSAIC/20200425")
# for (prefix in c("Bangweulu_2way_1-36","Bemba_2way_1-13","Kafue_2way_1-33","Lozi_2way_1-23","Tonga_2way_1-9")) {
#     load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1950_60_0.99_100.RData",sep="")) #model parameters
#     load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1950_60_0.99_100.RData",sep="")) #local ancestry
#     pdf (file=paste(prefix,"_1-22_1956_60_0.99_100_mu_new.pdf"), width =30, height = 15, pointsize =15)
#     plot_Mu_Gwenna(Mu,alpha,NL)
#     dev.off()
#     pdf (file=paste(prefix,"_1-22_1950_60_0.99_100_Fst_new.pdf"), width =30, height = 15, pointsize =15)
#     plot_Fst_Gwenna(all_Fst$panels,ord=T)
#     dev.off()
#   }
  
prefix="Tonga_2way_1-9"
load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1950_60_0.99_100.RData",sep="")) #model parameters
load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1950_60_0.99_100.RData",sep="")) #local ancestry
Fst <- plot_Fst_Gwenna(all_Fst$panels,ord=T)
Fst

#20200717 runs
#I do not want to redo the plots, I only want to get the values of FST.

setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/MOSAIC/")
#prefix="Nzime_2way_1-36"
prefix="SEBantu_2way_1-19"
load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #model parameters
load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #local ancestry
Fst <- plot_Fst_Gwenna(all_Fst$panels,ord=T)
Fst
round(sort(Fst[[1]]),4)


Mu <- plot_Mu_Gwenna(Mu,alpha,NL)



