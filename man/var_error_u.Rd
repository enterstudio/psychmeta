% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/var_error.R
\name{var_error_u}
\alias{var_error_u}
\title{Estimate the error variance of u ratios}
\usage{
var_error_u(u, n_i, n_a = NA, dependent_sds = FALSE)
}
\arguments{
\item{u}{Vector of u ratios.}

\item{n_i}{Vector of incumbent-group sample sizes.}

\item{n_a}{Vector of applicant-group sample sizes.}

\item{dependent_sds}{Logical vector identifying whether each u ratio is based on standard deviations from independent samples (FALSE) or based on
standard deviations from an applicant sample and an incumbent sample that is a subset of that applicant sample (TRUE).}
}
\value{
A vector of sampling-error variances.
}
\description{
Estimate the error variance of u ratios
}
\details{
The sampling variance of a u ratio is computed differently for independent samples (i.e., settings where the referent unrestricted standard deviations comes from an different sample than the range-restricted standard deviation) than for dependent samples (i.e., unrestricted samples from which a subset of individuals are selected to be in the incumbent sample).

The sampling variance for independent samples (the more common case) is:

\deqn{var_{e}=\frac{u^{2}}{2}\left(\frac{1}{n_{i}-1}+\frac{1}{n_{a}-1}\right)}{var_e = .5 * u^2 * (1 / (ni - 1) + 1 / (na - 1))}

and the sampling variance for dependent samples is:

\deqn{var_{e}=\frac{u^{2}}{2}\left(\frac{1}{n_{i}-1}-\frac{1}{n_{a}-1}\right)}{var_e = .5 * u^2 * (1 / (ni - 1) - 1 / (na - 1))}

where \emph{u} is the u ratio, \eqn{n_{i}}{ni} is the incumbent sample size, and \eqn{n_{a}}{na} is the applicant sample size.
}
\examples{
var_error_u(u = .8, n_i = 100, n_a = 200)
var_error_u(u = .8, n_i = 100, n_a = NA)
}
\references{
Dahlke, J. A., & Wiernik, B. M. (2017).
\emph{One of these artifacts is not like the others: New methods to account for the unique implications of indirect range-restriction corrections in organizational research}.
Unpublished manuscript.
}
