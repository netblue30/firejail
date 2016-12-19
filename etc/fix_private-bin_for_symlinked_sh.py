#!/usr/bin/python3

import sys, os, glob, re

privRx=re.compile("^(?:#\s*)?private-bin")

def fixSymlinkedBins(files, replMap):
	rxs=dict()
	for (old,new) in replMap.items():
		rxs[old]=re.compile("\\b"+old+"\\b")
		rxs[new]=re.compile("\\b"+new+"\\b")
	print(rxs)
	
	for filename in files:
		lines=None
		with open(filename,"r") as file:
			lines=file.readlines()
		
		shouldUpdate=False
		for (i,line) in enumerate(lines):
			if privRx.search(line):
				for (old,new) in replMap.items():
					if rxs[old].search(line) and not rxs[new].search(line):
						lines[i]=rxs[old].sub(old+","+new, line)
						shouldUpdate=True
						print(lines[i])
		
		if shouldUpdate:
			with open(filename,"w") as file:
				file.writelines(lines)
				pass

def createListOfBinaries(files):
	s=set()
	for filename in files:
		lines=None
		with open(filename,"r") as file:
			for line in file:
				if privRx.search(line):
					bins=line.split(",")
					bins[0]=bins[0].split(" ")[-1]
					bins = [n.strip() for n in bins]
					s=s|set(bins)
	return s

def createSymlinkTable(binDirs, binariesSet):
	m=dict()
	for sh in binariesSet:
		for bD in binDirs:
			p=bD+os.path.sep+sh
			if os.path.exists(p):
				if os.path.islink(p):
					m[sh]=os.readlink(p)
				else:
					pass
				break
	return m


sh="sh"
binDirs=["/bin","/usr/bin","/usr/sbin","/usr/local/bin","/usr/local/sbin"]
profilesPath="."
files=glob.glob(profilesPath+os.path.sep+"*.profile")

bins=createListOfBinaries(files)
stbl=createSymlinkTable(binDirs,bins)
print(stbl)
fixSymlinkedBins(files,{a[0]:a[1] for a in stbl.items() if a[0].find("/") < 0 and a[1].find("/")<0})
