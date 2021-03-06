% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_r.R
\name{sparsify_simdat_r}
\alias{sparsify_simdat_r}
\title{Create sparse artifact information in a "simdat_r" class object}
\usage{
sparsify_simdat_r(data_obj, prop_missing, sparify_arts = c("rel", "u"),
  study_wise = TRUE)
}
\arguments{
\item{data_obj}{Object created by the "simdat_r" function.}

\item{prop_missing}{Proportion of studies in from which artifact information should be deleted.}

\item{sparify_arts}{Vector of codes for the artifacts to be sparsified: "rel" for reliabilities, "u" for u ratios, or c("rel", "u") for both.}

\item{study_wise}{Logical scalar argument determining whether artifact deletion should occur for all variables in a study (\code{TRUE}) or randomly across variables within studies (\code{FALSE}).}
}
\value{
A sparsified database
}
\description{
This function can be used to randomly delete artifact from databases produced by the \code{\link{simulate_r_database}} function.
Deletion of artifacts can be performed in either a study-wise fashion for complete missingness within randomly selected studies or element-wise missingness for compeltely random deletion of artifacts in the database.
Deletion can be applied to reliability estimates and/or u ratios.
}
