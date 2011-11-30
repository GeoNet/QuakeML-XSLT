QuakeML Transforms
==================

This project provides XSLT transforms for some versions of QuakeML and the 
closesly related SeisComPML

Running the Transforms
======================

The XSLTs are version 2 and need an engine that supports that to run them.

On the command line I use saxonica:

http://www.saxonica.com/welcome/welcome.xml

Specifically the 'home edition':

http://sourceforge.net/projects/saxon/files/Saxon-HE/9.3/saxonhe9-3-0-5j.zip/download

There is full documentation on line, getting started is here

http://www.saxonica.com/documentation/about/gettingstarted/gettingstartedjava.xml

Note this needs Oracle Java JRE 1.5 or higher.  It may not work on other Java implementations.

Examples
--------

mkdir /work/in
mkdir /work/out

wget "http://magma.geonet.org.nz/services/quake/quakeml/1.0.1/query?startDate=2008-07-01T10:00:00&endDate=2008-08-01T10:30:00&includePicksAndArrivals=true&includeAmplitudesAndStationMagnitudes=true&includeMultipleMagnitudes=true" -O /work/test-in/in.xml

java -cp ~/Downloads/saxon9he.jar net.sf.saxon.Transform -t -s:/work/in  -xsl:/home/geoffc/GeoNet/quakeml-xslt/xslt/quakeml1.0.1toantelope.xslt  -o:/work/out

All XML files in /work/test-in are processed and a corresponding transformed file output to /work/out



Possible Problems

The most likely problem is the JVM running out of memory when trying to process very large files.  If out of memory errors occur then try increasing memory allocation to the JVM.
See the Java docs or the performance section of

http://www.geonet.org.nz/resources/basic-data/waveform-data/



