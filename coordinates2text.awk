BEGIN {
    print id, "\t", m, "\t";
}
NR==1 {
    print $0, "\t";
}
{
    if (s<w) {
	if (e+w+1>NF) {
	    for (i=1;i<=NF;i++) printf("%s",$(i));
	} 
	else {
	    for (i=1;i<=e+w+1;i++) printf("%s",$(i));
	}
    }
    else {
	if (e+w+1>NF) {
	    for (i=s-w;i<=NF;i++) printf("%s",$(i));
	}
	else {
	    for (i=s-w;i<=e+w+1;i++) printf("%s", $(i));
	}
    }
}
END {
    print "\n";
}
