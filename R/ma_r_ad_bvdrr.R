#' Interactive artifact-distribution meta-analysis correcting for Case V indirect range restriction and measurement error
#'
#' @param x List of bare-bones meta-analytic data, artifact-distribution objects for X and Y, and other meta-analysis options.
#'
#' @return A meta-analysis class object containing all results.
#' @keywords internal
"ma_r_ad.int_bvdrr" <- function(x){

     barebones <- x$barebones
     ad_obj_x <- x$ad_obj_x
     ad_obj_y <- x$ad_obj_y
     correct_rxx <- x$correct_rxx
     correct_ryy <- x$correct_ryy
     residual_ads <- x$residual_ads
     cred_level <- x$cred_level
     cred_method <- x$cred_method
     var_unbiased <- x$var_unbiased

     k <- barebones[,"k"]
     N <- barebones[,"N"]
     mean_rxyi <- barebones[,"mean_r"]
     var_r <- barebones[,"var_r"]
     var_e <- barebones[,"var_e"]
     var_res <- barebones[,"var_res"]
     ci_xy_i <- barebones[,grepl(x = colnames(barebones), pattern = "CI")]

     if(correct_rxx){
          mean_qxa <- wt_mean(x = ad_obj_x$qxa_drr$Value, wt = ad_obj_x$qxa_drr$Weight)
     }else{
          ad_obj_x$qxa_drr <- data.frame(Value = 1, Weight = 1)
          mean_qxa <- 1
     }

     if(correct_ryy){
          mean_qya <- wt_mean(x = ad_obj_y$qxa_drr$Value, wt = ad_obj_y$qxa_drr$Weight)
     }else{
          ad_obj_y$qxa_drr <- data.frame(Value = 1, Weight = 1)
          mean_qya <- 1
     }

     mean_ux <- wt_mean(x = ad_obj_x$ux$Value, wt = ad_obj_x$ux$Weight)
     mean_uy <- wt_mean(x = ad_obj_y$ux$Value, wt = ad_obj_y$ux$Weight)

     ad_list <- list(qxa = ad_obj_x$qxa_drr,
                     qya = ad_obj_y$qxa_drr,
                     ux = ad_obj_x$ux,
                     uy = ad_obj_y$ux)
     art_grid <- create_ad_array(ad_list = ad_list, name_vec = names(ad_list))

     qxa <- art_grid$qxa
     qya <- art_grid$qya
     ux <- art_grid$ux
     uy <- art_grid$uy
     wt_vec <- art_grid$wt

     mean_rtpa <- .correct_r_bvdrr(rxyi = mean_rxyi, qxa = mean_qxa, qya = mean_qya, ux = mean_ux, uy = mean_uy)
     ci_tp <- .correct_r_bvdrr(rxyi = ci_xy_i, qxa = mean_qxa, qya = mean_qya, ux = mean_ux, uy = mean_uy)

     var_art_tp <- apply(t(mean_rtpa), 2, function(x){
          wt_var(x = .attenuate_r_bvdrr(rtpa = x, qxa = qxa, qya = qya, ux = ux, uy = uy), wt = wt_vec, unbiased = var_unbiased)
     })
     var_pre_tp <- var_e + var_art_tp
     var_res_tp <- var_r - var_pre_tp
     var_rho_tp <-  estimate_var_rho_int_bvdrr(mean_rxyi = mean_rxyi, mean_rtpa = mean_rtpa,
                                mean_qxa = mean_qxa, mean_qya = mean_qya,
                                mean_ux = mean_ux, mean_uy = mean_uy, var_res = var_res_tp)

     mean_rxpa <- mean_rtpa * mean_qxa
     ci_xp <- ci_tp * mean_qxa
     var_rho_xp <- var_rho_tp * mean_qxa^2

     mean_rtya <- mean_rtpa * mean_qya
     ci_ty <- ci_tp * mean_qya
     var_rho_ty <- var_rho_tp * mean_qya^2

     sd_r <- var_r^.5
     sd_e <- var_e^.5

     sd_art_tp <- var_art_tp^.5
     sd_pre_tp <- var_pre_tp^.5
     sd_res_tp <- var_res_tp^.5
     sd_rho_tp <- var_rho_tp^.5

     sd_rho_xp <- var_rho_xp^.5
     sd_rho_ty <- var_rho_ty^.5

     correct_meas_x <- !(all(qxa == 1))
     correct_meas_y <- !(all(qya == 1))
     correct_drr <- !(all(ux == 1) & all(uy == 1))

     out <- as.list(environment())
     class(out) <- class(x)
     out
}




#' Taylor series approximation artifact-distribution meta-analysis correcting for Case V indirect range restriction and measurement error
#'
#' @param x List of bare-bones meta-analytic data, artifact-distribution objects for X and Y, and other meta-analysis options.
#'
#' @return A meta-analysis class object containing all results.
#' @keywords internal
"ma_r_ad.tsa_bvdrr" <- function(x){

     barebones <- x$barebones
     ad_obj_x <- x$ad_obj_x
     ad_obj_y <- x$ad_obj_y
     correct_rxx <- x$correct_rxx
     correct_ryy <- x$correct_ryy
     residual_ads <- x$residual_ads
     cred_level <- x$cred_level
     cred_method <- x$cred_method
     var_unbiased <- x$var_unbiased

     k <- barebones[,"k"]
     N <- barebones[,"N"]
     mean_rxyi <- barebones[,"mean_r"]
     var_r <- barebones[,"var_r"]
     var_e <- barebones[,"var_e"]
     var_res <- barebones[,"var_res"]
     ci_xy_i <- barebones[,grepl(x = colnames(barebones), pattern = "CI")]

     var_label <- ifelse(residual_ads, "var_res", "var")

     mean_qxa <- ad_obj_x["qxa_drr", "mean"]
     mean_qya <- ad_obj_y["qxa_drr", "mean"]
     mean_ux = ad_obj_x["ux", "mean"]
     mean_uy = ad_obj_y["ux", "mean"]

     var_qxa = ad_obj_x["qxa_drr", var_label]
     var_qya = ad_obj_y["qxa_drr", var_label]
     var_ux = ad_obj_x["ux", var_label]
     var_uy = ad_obj_y["ux", var_label]

     if(!correct_rxx){
          mean_qxa <- 1
          var_qxa <- 0
     }

     if(!correct_ryy){
          mean_qya <- 1
          var_qya <- 0
     }


     mean_rtpa <- .correct_r_bvdrr(rxyi = mean_rxyi, qxa = mean_qxa, qya = mean_qya,
                           ux = mean_ux, uy = mean_uy)
     ci_tp <- .correct_r_bvdrr(rxyi = ci_xy_i, qxa = mean_qxa, qya = mean_qya,
                       ux = mean_ux, uy = mean_uy)

     var_mat_tp <- estimate_var_rho_tsa_bvdrr(mean_rtpa = mean_rtpa, var_rxyi = var_r, var_e = var_e,
                                mean_ux = mean_ux, mean_uy = mean_uy, mean_qxa = mean_qxa, mean_qya = mean_qya,
                                var_ux = var_ux, var_uy = var_uy, var_qxa = var_qxa, var_qya = var_qya)

     var_art_tp <- var_mat_tp$var_art
     var_pre_tp <- var_mat_tp$var_pre
     var_res_tp <- var_mat_tp$var_res
     var_rho_tp <- var_mat_tp$var_rho

     mean_rxpa <- mean_rtpa * mean_qxa
     ci_xp <- ci_tp * mean_qxa
     var_rho_xp <- var_rho_tp * mean_qxa^2

     mean_rtya <- mean_rtpa * mean_qya
     ci_ty <- ci_tp * mean_qya
     var_rho_ty <- var_rho_tp * mean_qya^2

     sd_r <- var_r^.5
     sd_e <- var_e^.5

     sd_art_tp <- var_art_tp^.5
     sd_pre_tp <- var_pre_tp^.5
     sd_res_tp <- var_res_tp^.5
     sd_rho_tp <- var_rho_tp^.5

     sd_rho_xp <- var_rho_xp^.5
     sd_rho_ty <- var_rho_ty^.5

     correct_meas_x <- mean_qxa != 1
     correct_meas_y <- mean_qya != 1
     correct_drr <- mean_ux != 1 & mean_uy != 1

     out <- as.list(environment())
     class(out) <- class(x)
     out
}




