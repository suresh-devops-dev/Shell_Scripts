import sys,os
file1 = open(sys.argv[1],"r")
file2 = open(sys.argv[2],"r")
lines1 = file1.readlines()
lines2 = file2.readlines()
print "File %s has %s lines" % (sys.argv[1],len(lines1))
print "File %s has %s lines" % (sys.argv[2],len(lines2))
found = []
notfound = []
for idx,l in enumerate(lines1) :
	print "Doing line %s in file %s : %s" % (idx,sys.argv[1],l)
	for idx2,l2 in enumerate(lines2) :
		if l == l2 :
			print "Found %s ( ==  %s ) in file %s at index %s" % (l,l2, sys.argv[2],idx2)
			found.append(l)
			continue
			print "Found : %s , Not Found : %s" % (len(found),len(notfound))
	notfound.append(l)
	print "Found : %s , Not Found : %s" % (len(found),len(notfound))
