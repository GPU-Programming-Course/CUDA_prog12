NVCC = /usr/bin/nvcc
CC = g++

#No optmization flags
#--compiler-options sends option to host compiler; -Wall is all warnings
#NVCCFLAGS = -c --compiler-options -Wall

#Optimization flags: -O2 gets sent to host compiler; -Xptxas -O2 is for
#optimizing PTX
NVCCFLAGS = -c -O2 -Xptxas -O2 --compiler-options -Wall

#Flags for debugging
#NVCCFLAGS = -c -G --compiler-options -Wall --compiler-options -g

OBJS = classify.o wrappers.o h_classify.o d_classify.o
.SUFFIXES: .cu .o .h 
.cu.o:
	$(NVCC) $(CC_FLAGS) $(NVCCFLAGS) $(GENCODE_FLAGS) $< -o $@

all: classify buildHeaders

classify: $(OBJS)
	$(CC) $(OBJS) -L/usr/local/cuda/lib64 -lcuda -lcudart -ljpeg -o classify

buildHeaders: buildHeaders.c config.h histogram.h
	$(CC) -g buildHeaders.c -o buildHeaders -ljpeg

classify.o: classify.cu wrappers.h h_classify.h d_classify.h config.h histogram.h models.h

h_classify.o: h_classify.cu h_classify.h CHECK.h config.h histogram.h

d_classify.o: d_classify.cu d_classify.h CHECK.h config.h histogram.h

wrappers.o: wrappers.cu wrappers.h

clean:
	rm classify buildHeaders *.o
