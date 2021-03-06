% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matreg.R
\name{confint.summary_lm_mat}
\alias{confint.summary_lm_mat}
\title{Confidence interval method for objects of the class "summary_lm_mat"}
\usage{
\method{confint}{summary_lm_mat}(object, parm, level = 0.95, ...)
}
\arguments{
\item{object}{Object of class "summary_lm_mat"}

\item{parm}{a specification of which parameters are to be given confidence intervals, either a vector of numbers or a vector of names. If missing, all parameters are considered.}

\item{level}{Confidence level}

\item{...}{further arguments passed to or from other methods.}
}
\value{
Lower and upper bounds of confidence intervals for regression coefficients.
}
\description{
Confidence interval method for objects of the class "summary_lm_mat"
}
