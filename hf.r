# hf.r

# Generation of a  Fault Tree cases demonstrated in a presentation to
# The 12th IMA International Conference on Modelling in Industrial Maintenance and Reliability
# 4-6 July 2023

require(FaultTree)

rv_test=3
pi_test=1
walkby=1/12
 
hf<-ftree.make(type="or", name="HF Vaporizer", name2="Rupture")
hf<-addLogic(hf, at=1, type="inhibit", name="Overpressure", name2="Unrelieved")
hf<-addDemand(hf, at=1, mttf=1e6, name= "Vaporizer Rupture", name2="Due to Stress/Fatigue")
hf<-addLogic(hf, at=2, type="or", name="Pressure Relief System", name2="in Failed State")
hf<-addLogic(hf, at=2, type="or", name="Overpressure", name2="Occurs")
hf<-addLogic(hf, at=4, type="or", name="Pressure Relief", name2="Isolated")
hf<-addLatent(hf, at=6, mttf=10, inspect=walkby, name="Valve 20", name2="Left Closed")
hf<-addLatent(hf, at=6, mttf=10, inspect=walkby, display_under=7,
name="Valve 21", name2="Left Closed")
hf<-addLogic(hf, at=4, type="or", name="Rupture Disk Fails", name2="to Open at Design Pt.")
hf<-addLogic(hf, at=9, type="or", name="Installation/Mfr", name2="Errors")
hf<-addProbability(hf, at=10, prob=.001, name="Rupture Disk", name2="Installed Upside Down")
hf<-addProbability(hf, at=10, prob=.001, display_under=11,
name="Wrong Rupture Disk", name2="Installed")
hf<-addProbability(hf, at=10, prob=.001, display_under=12,
name="Rupture Disk", name2="Manuf. Error")
hf<-addLogic(hf, at=9, type="or", name="Pressure Between Disk", name2="and Relief Valve")
hf<-addLogic(hf, at=14, type="inhibit", name="Pressure NOT" , name2="Detectable by PI")
hf<-addLatent(hf, at=15, mttf=10, inspect=pi_test,
name="Pressure Gage", name2="Failed Low Position")
hf<-addLatent(hf, at=15, mttf=10, inspect=pi_test,
name="Rupture Disk Leak", name2="Undetected")
hf<-addLogic(hf, at=14, type="inhibit", name="Pressure" , name2="Detectable by PI")
hf<-addProbability(hf, at=18, prob=1-4.8374e-2, name="Pressure Gage", name2="Detects Pressure")
hf<-addLatent(hf, at=18, mttf=10, inspect=walkby,
name="Rupture Disk Leak", name2="Detectable")
hf<-addLogic(hf, at=4, type="or", name="Pressure Relief Fails", name2=" to Open at Design Pt")
hf<-addLatent(hf, at=21, mttf=300, inspect=rv_test,
name="Pressure Relief", name2="set too high")
hf<-addLatent(hf, at=21, mttf=300, inspect=rv_test,
name="Pressure Relief Unable", name2="to Open at Design Pt")
hf<-addDemand(hf, at=5, mttf=10, name= "High Pressure", name2="Feed to Vaporizer")
hf<-addDemand(hf, at=5, mttf=10, name= "Vaporizer Heating", name2="Runaway") 

hf<-ftree.calc(hf)
ftree2html(hf, write_file=TRUE)
browseURL("hf.html") 