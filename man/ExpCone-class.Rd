% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/constraints.R
\docType{class}
\name{ExpCone-class}
\alias{ExpCone-class}
\alias{.ExpCone}
\alias{ExpCone}
\alias{ExpCone}
\alias{size,ExpCone-method}
\alias{as.character,ExpCone-method}
\alias{variables,ExpCone-method}
\alias{format_constr,ExpCone-method}
\title{The ExpCone class.}
\usage{
ExpCone(a, b, c)

\S4method{size}{ExpCone}(object)

\S4method{as.character}{ExpCone}(x)

\S4method{variables}{ExpCone}(object)

\S4method{format_constr}{ExpCone}(object, eq_constr, leq_constr, dims, solver)
}
\arguments{
\item{a}{The variable \eqn{a} in the exponential cone.}

\item{b}{The variable \eqn{b} in the exponential cone.}

\item{c}{The variable \eqn{c} in the exponential cone.}

\item{x, object}{A \linkS4class{ExpCone} object.}

\item{eq_constr}{A list of the equality constraints in the canonical problem.}

\item{leq_constr}{A list of the inequality constraints in the canonical problem.}

\item{dims}{A list with the dimensions of the conic constraints.}

\item{solver}{A string representing the solver to be called.}
}
\description{
This class represents a reformulated exponential cone constraint operating elementwise on \eqn{a, b, c}.
}
\details{
Original cone:
\deqn{
K = \{(a,b,c) | b > 0, be^{a/b} \leq c\} \cup \{(a,b,c) | a \leq 0, b = 0, c \geq 0\}
}
Reformulated cone:
\deqn{
K = \{(a,b,c) | b, c > 0, b\log(b) + a \leq b\log(c)\} \cup \{(a,b,c) | a \leq 0, b = 0, c \geq 0\}
}
}
\section{Methods (by generic)}{
\itemize{
\item \code{size}: The size of the \code{x} argument.

\item \code{variables}: List of \linkS4class{Variable} objects in the exponential cone.

\item \code{format_constr}: Format exponential cone constraints for the solver.
}}

\section{Slots}{

\describe{
\item{\code{constr_id}}{(Internal) A unique integer identification number used internally.}

\item{\code{a}}{The variable \eqn{a} in the exponential cone.}

\item{\code{b}}{The variable \eqn{b} in the exponential cone.}

\item{\code{c}}{The variable \eqn{c} in the exponential cone.}
}}

