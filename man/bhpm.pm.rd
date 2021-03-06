\name{bhpm.pm}
\alias{bhpm.pm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{A Bayesian Hierarchical Model for grouped data and clusters with Point-Mass.}
\description{
Implementation of a bayesian Hierarchical for grouped data and clusters with Point-Mass.}
\usage{
	bhpm.pm(cluster.data, hier = 3, sim_type = "SLICE", burnin = 20000,
	iter = 60000, nchains = 5, theta_algorithm = "MH",
	global.sim.params = NULL,
	sim.params = NULL,
	monitor = NULL,
	initial_values = NULL, level = 1, hyper_params = NULL,
	global.pm.weight = 0.5,
	pm.weights = NULL,
	adapt_phase=1, memory_model = "HIGH")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{cluster.data}{
A file or data frame containing the cluster data. It must contain the columns \emph{Cluster}, \emph{Outcome.Grp}, \emph{Outcome}, \emph{Trt.Grp} (1 - control, 2,... comparator treatments), \emph{Count} (total number of events), \emph{Exposure} (total exposure of time of all patients fot the Trt.Grp in the Cluster).
}
  \item{hier}{
	Fit a 2 or 3 level model.
	}
  \item{burnin}{
The burnin period for the monte-carlo simulation. These are discarded from the returned samples.
}
  \item{iter}{
The total number of iterations for which the monte-carlo simulation is run. This includes the burnin period.
The total number of samples returned is \emph{iter - burnin}
}
  \item{nchains}{
The number of independent chains to run.
}
  \item{theta_algorithm}{
MCMC algorithm used to sample the theta variables. "MH" is the only currently supported stable algorithm.
}
  \item{sim_type}{
The type of MCMC method to use for simulating from non-standard distributions apart from theta. Allowed values are \emph{"MH"} and \emph{"SLICE"} for Metropis_Hastings and Slice sampling respectively.
}

\item{monitor}{
A dataframe indicating which sets of variables to monitor.
Passing NULL uses the model defaults.
}

\item{global.sim.params}{
A data frame containing the parameters for the simuation type \emph{sim_type}. For \emph{"MH"} the parameter
is the variance of the normal distribution used to simulate the next candidate value centred on the current
value. For \emph{"SLICE"} the parameters are the estimated width of the slice and a value limiting the search for the next sample.
Passing NULL uses the model defaults.
}
\item{sim.params}{
A dataframe containing simulation parameters which override the global simulation parameters (\emph{global.sim.params}) for particular model
parameters. \emph{sim.params} must contain the following columns: type: the simulation type ("MH" or "SLICE"); variable: the model parameter 
for which the simulation parameters are being overridden; Outcome.Grp (if applicable); Outcome (if applicable);
param: the simulation parameter; value: the overridden value; control: the overridden control value.

The function \emph{bhpm.sim.control.params} generates a template for \emph{sim.params} which can be edited by the user.
}
\item{initial_values}{
The initial values for starting the chains. If NULL (the default) is passed the function generates the initial
values for the chains. initial_values is a list with the following format:
\preformatted{
list(gamma, theta, mu.gamma, mu.theta, sigma2.gamma,
	sigma2.theta, pi, mu.gamma.0, mu.theta.0,
	tau2.gamma.0, tau2.theta.0, alpha.pi, beta.pi)
}
The function \emph{bhpm.gen.initial.values} can be used to generate a template for the list which can be updated by the user if required.
}
  \item{level}{
Allowed valus are 0, 1, 2. Respectively these indicate independent clusters, common means across the clusters and weak relationships between the clusters.
}
  \item{hyper_params}{
The hyperparameters for the model.
Passing NULL uses the model defaults.
}

\item{global.pm.weight}{A global weighting for the proposal distribution used to sample theta.}
\item{pm.weights}{Override global.pm.weight for specific outcomes.}

  \item{adapt_phase}{
Unused parameter.
}

\item{memory_model}{
Allowed values are "HIGH" and "LOW". "HIGH" means use as much memory as possible. "LOW" means use the minimum amount of memory.
}
}
\details{
The model is fitted by a Gibbs sampler.
}
\value{
The output from the simulation including all the sampled values is as follows:
\preformatted{
list(id, theta_alg, sim_type, chains, nClusters, Clusters, nOutcome.Grp,
	maxOutcome.Grps, maxOutcomes, nAE, AE, B, burnin,
	iter, monitor, mu.gamma.0, mu.theta.0, tau2.gamma.0, tau2.theta.0,
	mu.gamma, mu.theta, sigma2.gamma, sigma2.theta, pi, alpha.pi, beta.pi,
	alpha.pi_acc, beta.pi_acc, gamma, theta, gamma_acc, theta_acc)
}
where

\emph{id} - a string identifying the verions of the function.

\emph{theta_alg} - an string identifying the algorithm used to smaple theta.

\emph{sim_type} - an string identifying the samlping method used for non-standard distributions, either \emph{"MH"} or \emph{"SLICE"}.

\emph{chains} - the number of chains for which the simulation was run.

\emph{nClusters} - the number of clusters in the simulation.

\emph{Clusters} - an array. The clusters.

\emph{nOutcome.Grp} - the number of outcome groupings.

\emph{maxOutcome.Grps} - the maximum number of outcome groupings in a cluster.

\emph{maxOutcomes} - the maximum number of outcome in a outcome grouping.

\emph{nOutcome} - an array. The number of outcomes in each outcome grouping.

\emph{Outcome} - an array of dimension \emph{nOutcome.Grp}, \emph{maxOutcomes}. The outcomes.

\emph{Outcome.Grp} - an array. The outcome groupings.

\emph{burnin} - burnin used for the simulation.

\emph{iter} - the total number of iterations in the simulation.

\emph{monitor} - the variables being monitored. A dataframe.

\emph{mu.gamma.0} - array of generated samples.

\emph{mu.theta.0} - array of generated samples.

\emph{tau2.gamma.0} - array of generated samples.

\emph{tau2.theta.0} - array of generated samples.

\emph{mu.gamma} - array of generated samples.

\emph{mu.theta} - array of generated samples.

\emph{sigma2.gamma} - array of generated samples.

\emph{sigma2.theta} - array of generated samples.

\emph{pi} - array of generated samples.
\emph{alpha.pi} - array of generated samples.
\emph{beta.pi} - array of generated samples.

\emph{alpha.pi_acc} - the acceptance rate for the alpha.pi samples if a Metropolis-Hastings method is used.

\emph{beta.pi_acc} - the acceptance rate for the beta.pi samples if a Metropolis-Hastings method is used.


\emph{gamma} - array of generated samples.

\emph{theta} - array of generated samples.

\emph{gamma_acc} - the acceptance rate for the gamma samples if a Metropolis-Hastings method is used.

\emph{theta_acc} - the acceptance rate for the theta samples.

}
%\references{
%}
\author{
R. Carragher
}
\note{
The function performs the simulation and returns the raw output. No checks for convergence are performed. 
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{

data(bhpm.cluster.data1)
raw = bhpm.pm(cluster.data = bhpm.cluster.data1, burnin = 100, iter = 200)

\donttest{
data(bhpm.cluster.data1)
raw = bhpm.pm(cluster.data = bhpm.cluster.data1)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{bhpm.cluster.BB.hier3}
\keyword{Bayesian} % __ONLY ONE__ keyword per line
\keyword{Hierarchy} % __ONLY ONE__ keyword per line
\keyword{Point-mass} % __ONLY ONE__ keyword per line
\keyword{Cluster} % __ONLY ONE__ keyword per line
\keyword{Adverse event} % __ONLY ONE__ keyword per line
\keyword{Adverse outcome} % __ONLY ONE__ keyword per line
