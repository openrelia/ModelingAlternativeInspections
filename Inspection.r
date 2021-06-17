# Inspection.r

# This script prepares an illustration of failure probability over time for an inspected system.
# A dependency is drawn upon an external program,SCRAM, which is a probabilistic Risk Assessment Tool.
# SCRAM is available for download at https://sourceforge.net/projects/iscram/
# An R interface to SCRAM is provided by package FaultTree.SCRAM, which is available 
# on the R-Forge repository at https://r-forge.r-project.org/R/?group_id=2125

require(FaultTree.SCRAM)

outvec<-NULL	
	
for(days in 1:60) {	
	mission_time =days/365
	egen<-ftree.make(type="or", name="generator unavailable")
	egen <- addLatent(egen, at=1, mttf=5,mttr=12/8760,inspect=1/26, name="e-gen set fails")
	prob<- scram.probability(egen)
	outvec<-rbind(outvec, c(days, prob))
}	

plot(outvec, ylim=c(0, .008), type="l",
ylab = "Probability  of  Failure", xlab = "Mission Days",
main = "Markov Model of Inspected System")

outvec