#
#  Makefile
#  Licence : https://github.com/wolfviking0/webcl-translator/blob/master/LICENSE
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

# Default parameter
DEB = 0
VAL = 0
NAT = 0
ORIG= 0
FAST= 1

# Chdir function
CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

# Current Folder
CURRENT_ROOT:=$(PWD)

# Emscripten Folder
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../webcl-translator/emscripten

# Native build
ifeq ($(NAT),1)
$(info ************ NATIVE : (GLEW)           ************)

CXX = clang++
CC  = clang

BUILD_FOLDER = $(CURRENT_ROOT)/bin/
EXTENSION = .out

ifeq ($(DEB),1)
$(info ************ NATIVE : DEBUG = 1        ************)

CFLAGS = -O0 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics -DGPU_PROFILING -lGLEW

else
$(info ************ NATIVE : DEBUG = 0        ************)

CFLAGS = -O2 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics -DGPU_PROFILING -lGLEW

endif

# Emscripten build
else
ifeq ($(ORIG),1)
$(info ************ EMSCRIPTEN : SUBMODULE     = 0 ************)

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../emscripten
else
$(info ************ EMSCRIPTEN : SUBMODULE     = 1 ************)
endif

CXX = $(EMSCRIPTEN_ROOT)/em++
CC  = $(EMSCRIPTEN_ROOT)/emcc

BUILD_FOLDER = $(CURRENT_ROOT)/js/
EXTENSION = .js
GLOBAL =

ifeq ($(DEB),1)
$(info ************ EMSCRIPTEN : DEBUG         = 1 ************)

GLOBAL += EMCC_DEBUG=1

CFLAGS = -s OPT_LEVEL=1 -s DEBUG_LEVEL=1 -s CL_PRINT_TRACE=1 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1
else
$(info ************ EMSCRIPTEN : DEBUG         = 0 ************)

CFLAGS = -s OPT_LEVEL=3 -s DEBUG_LEVEL=0 -s CL_PRINT_TRACE=0 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=0 -s CL_CHECK_VALID_OBJECT=0
endif

ifeq ($(VAL),1)
$(info ************ EMSCRIPTEN : VALIDATOR     = 1 ************)

PREFIX = val_

CFLAGS += -s CL_VALIDATOR=1
else
$(info ************ EMSCRIPTEN : VALIDATOR     = 0 ************)
endif

ifeq ($(FAST),1)
$(info ************ EMSCRIPTEN : FAST_COMPILER = 1 ************)

GLOBAL += EMCC_FAST_COMPILER=1
else
$(info ************ EMSCRIPTEN : FAST_COMPILER = 0 ************)
endif

endif

	
SOURCES_common					= $(CURRENT_ROOT)/NVIDIA_GPU_Computing_SDK/OpenCL/common/src/oclUtils.cpp $(CURRENT_ROOT)//NVIDIA_GPU_Computing_SDK/shared/src/cmd_arg_reader.cpp $(CURRENT_ROOT)//NVIDIA_GPU_Computing_SDK/shared/src/shrUtils.cpp

SOURCES_bandwidthtest			= $(SOURCES_common) oclBandwidthTest.cpp
SOURCES_blackscholes			= $(SOURCES_common) src/main.cpp src/oclBlackScholes_gold.cpp src/oclBlackScholes_launcher.cpp
SOURCES_boxfilter				= $(SOURCES_common) BoxFilterHost.cpp oclBoxFilter.cpp 
SOURCES_convolutionseparable	= $(SOURCES_common)
SOURCES_copycomputeoverlap		= $(SOURCES_common)
SOURCES_dct8x8					= $(SOURCES_common)
SOURCES_devicequery				= $(SOURCES_common)
SOURCES_dotproduct				= $(SOURCES_common)
SOURCES_dxtcompression			= $(SOURCES_common)
SOURCES_fdtd3d					= $(SOURCES_common)
SOURCES_hiddenmarkovmodel		= $(SOURCES_common)
SOURCES_histogram				= $(SOURCES_common)
SOURCES_inlineptx				= $(SOURCES_common)
SOURCES_marchingcubes			= $(SOURCES_common)
SOURCES_matrixmul				= $(SOURCES_common)
SOURCES_matvecmul				= $(SOURCES_common)
SOURCES_mersennetwister			= $(SOURCES_common)
SOURCES_multithreads			= $(SOURCES_common)
SOURCES_nbody					= $(SOURCES_common)
SOURCES_particles				= $(SOURCES_common)
SOURCES_postprocessgl			= $(SOURCES_common)
SOURCES_quasirandomgenerator	= $(SOURCES_common)
SOURCES_radixsort				= $(SOURCES_common)
SOURCES_recursivegaussian		= $(SOURCES_common)
SOURCES_reduction				= $(SOURCES_common)
SOURCES_scan					= $(SOURCES_common)
SOURCES_simplegl				= $(SOURCES_common)
SOURCES_simplemultigpu			= $(SOURCES_common)
SOURCES_simpletexture3d			= $(SOURCES_common)
SOURCES_sobelfilter				= $(SOURCES_common)
SOURCES_sortingnetworks			= $(SOURCES_common)
SOURCES_transpose				= $(SOURCES_common)
SOURCES_tridiagonal				= $(SOURCES_common)
SOURCES_vectoradd				= $(SOURCES_common)
SOURCES_volumerender			= $(SOURCES_common)

INCLUDES_common					= -I$(EMSCRIPTEN_ROOT)/system/include -I$(CURRENT_ROOT)/NVIDIA_GPU_Computing_SDK/OpenCL/common/inc -I$(CURRENT_ROOT)//NVIDIA_GPU_Computing_SDK/shared/inc/

INCLUDES_bandwidthtest			= $(INCLUDES_common)
INCLUDES_blackscholes			= $(INCLUDES_common)
INCLUDES_boxfilter				= $(INCLUDES_common)
INCLUDES_convolutionseparable	= $(INCLUDES_common)
INCLUDES_copycomputeoverlap		= $(INCLUDES_common)
INCLUDES_dct8x8					= $(INCLUDES_common)
INCLUDES_devicequery			= $(INCLUDES_common)
INCLUDES_dotproduct				= $(INCLUDES_common)
INCLUDES_dxtcompression			= $(INCLUDES_common)
INCLUDES_fdtd3d					= $(INCLUDES_common)
INCLUDES_hiddenmarkovmodel		= $(INCLUDES_common)
INCLUDES_histogram				= $(INCLUDES_common)
INCLUDES_inlineptx				= $(INCLUDES_common)
INCLUDES_marchingcubes			= $(INCLUDES_common)
INCLUDES_matrixmul				= $(INCLUDES_common)
INCLUDES_matvecmul				= $(INCLUDES_common)
INCLUDES_mersennetwister		= $(INCLUDES_common)
INCLUDES_multithreads			= $(INCLUDES_common)
INCLUDES_nbody					= $(INCLUDES_common)
INCLUDES_particles				= $(INCLUDES_common)
INCLUDES_postprocessgl			= $(INCLUDES_common)
INCLUDES_quasirandomgenerator	= $(INCLUDES_common)
INCLUDES_radixsort				= $(INCLUDES_common)
INCLUDES_recursivegaussian		= $(INCLUDES_common)
INCLUDES_reduction				= $(INCLUDES_common)
INCLUDES_scan					= $(INCLUDES_common)
INCLUDES_simplegl				= $(INCLUDES_common)
INCLUDES_simplemultigpu			= $(INCLUDES_common)
INCLUDES_simpletexture3d		= $(INCLUDES_common)
INCLUDES_sobelfilter			= $(INCLUDES_common)
INCLUDES_sortingnetworks		= $(INCLUDES_common)
INCLUDES_transpose				= $(INCLUDES_common)
INCLUDES_tridiagonal			= $(INCLUDES_common)
INCLUDES_vectoradd				= $(INCLUDES_common)
INCLUDES_volumerender			= $(INCLUDES_common)

ifeq ($(NAT),0)

KERNEL_bandwidthtest			= 
KERNEL_blackscholes				= --preload-file BlackScholes.cl
KERNEL_boxfilter				= --preload-file BoxFilter.cl --preload-file data/lenaRGB.ppm
KERNEL_convolutionseparable		=
KERNEL_copycomputeoverlap		=
KERNEL_dct8x8					=
KERNEL_devicequery				=
KERNEL_dotproduct				=
KERNEL_dxtcompression			=
KERNEL_fdtd3d					=
KERNEL_hiddenmarkovmodel		=
KERNEL_histogram				=
KERNEL_inlineptx				=
KERNEL_marchingcubes			=
KERNEL_matrixmul				=
KERNEL_matvecmul				=
KERNEL_mersennetwister			=
KERNEL_multithreads				=
KERNEL_nbody					=
KERNEL_particles				=
KERNEL_postprocessgl			=
KERNEL_quasirandomgenerator		=
KERNEL_radixsort				=
KERNEL_recursivegaussian		=
KERNEL_reduction				=
KERNEL_scan						=
KERNEL_simplegl					=
KERNEL_simplemultigpu			=
KERNEL_simpletexture3d			=
KERNEL_sobelfilter				=
KERNEL_sortingnetworks			=
KERNEL_transpose				=
KERNEL_tridiagonal				=
KERNEL_vectoradd				=
KERNEL_volumerender				=

CFLAGS_bandwidthtest			= -s TOTAL_MEMORY=1024*1024*100
CFLAGS_blackscholes				= -s TOTAL_MEMORY=1024*1024*100
CFLAGS_boxfilter				=
CFLAGS_convolutionseparable		=
CFLAGS_copycomputeoverlap		=
CFLAGS_dct8x8					=
CFLAGS_devicequery				=
CFLAGS_dotproduct				=
CFLAGS_dxtcompression			=
CFLAGS_fdtd3d					=
CFLAGS_hiddenmarkovmodel		=
CFLAGS_histogram				=
CFLAGS_inlineptx				=
CFLAGS_marchingcubes			=
CFLAGS_matrixmul				=
CFLAGS_matvecmul				=
CFLAGS_mersennetwister			=
CFLAGS_multithreads				=
CFLAGS_nbody					=
CFLAGS_particles				=
CFLAGS_postprocessgl			=
CFLAGS_quasirandomgenerator		=
CFLAGS_radixsort				=
CFLAGS_recursivegaussian		=
CFLAGS_reduction				=
CFLAGS_scan						=
CFLAGS_simplegl					=
CFLAGS_simplemultigpu			=
CFLAGS_simpletexture3d			=
CFLAGS_sobelfilter				=
CFLAGS_sortingnetworks			=
CFLAGS_transpose				=
CFLAGS_tridiagonal				=
CFLAGS_vectoradd				=
CFLAGS_volumerender				=

VALPARAM_bandwidthtest			= 
VALPARAM_blackscholes			= -s CL_VAL_PARAM='[""]'
VALPARAM_boxfilter				= -s CL_VAL_PARAM='[""]'
VALPARAM_convolutionseparable	= -s CL_VAL_PARAM='[""]'
VALPARAM_copycomputeoverlap		= -s CL_VAL_PARAM='[""]'
VALPARAM_dct8x8					= -s CL_VAL_PARAM='[""]'
VALPARAM_devicequery			= -s CL_VAL_PARAM='[""]'
VALPARAM_dotproduct				= -s CL_VAL_PARAM='[""]'
VALPARAM_dxtcompression			= -s CL_VAL_PARAM='[""]'
VALPARAM_fdtd3d					= -s CL_VAL_PARAM='[""]'
VALPARAM_hiddenmarkovmodel		= -s CL_VAL_PARAM='[""]'
VALPARAM_histogram				= -s CL_VAL_PARAM='[""]'
VALPARAM_inlineptx				= -s CL_VAL_PARAM='[""]'
VALPARAM_marchingcubes			= -s CL_VAL_PARAM='[""]'
VALPARAM_matrixmul				= -s CL_VAL_PARAM='[""]'
VALPARAM_matvecmul				= -s CL_VAL_PARAM='[""]'
VALPARAM_mersennetwister		= -s CL_VAL_PARAM='[""]'
VALPARAM_multithreads			= -s CL_VAL_PARAM='[""]'
VALPARAM_nbody					= -s CL_VAL_PARAM='[""]'
VALPARAM_particles				= -s CL_VAL_PARAM='[""]'
VALPARAM_postprocessgl			= -s CL_VAL_PARAM='[""]'
VALPARAM_quasirandomgenerator	= -s CL_VAL_PARAM='[""]'
VALPARAM_radixsort				= -s CL_VAL_PARAM='[""]'
VALPARAM_recursivegaussian		= -s CL_VAL_PARAM='[""]'
VALPARAM_reduction				= -s CL_VAL_PARAM='[""]'
VALPARAM_scan					= -s CL_VAL_PARAM='[""]'
VALPARAM_simplegl				= -s CL_VAL_PARAM='[""]'
VALPARAM_simplemultigpu			= -s CL_VAL_PARAM='[""]'
VALPARAM_simpletexture3d		= -s CL_VAL_PARAM='[""]'
VALPARAM_sobelfilter			= -s CL_VAL_PARAM='[""]'
VALPARAM_sortingnetworks		= -s CL_VAL_PARAM='[""]'
VALPARAM_transpose				= -s CL_VAL_PARAM='[""]'
VALPARAM_tridiagonal			= -s CL_VAL_PARAM='[""]'
VALPARAM_vectoradd				= -s CL_VAL_PARAM='[""]'
VALPARAM_volumerender			= -s CL_VAL_PARAM='[""]'

else

COPY_bandwidthtest				=  
COPY_blackscholes				= cp BlackScholes.cl $(BUILD_FOLDER) &&
COPY_boxfilter					= mkdir -p $(BUILD_FOLDER)/data/ && cp BoxFilter.cl $(BUILD_FOLDER) && cp data/lenaRGB.ppm $(BUILD_FOLDER)/data/
COPY_convolutionseparable		=
COPY_copycomputeoverlap			=
COPY_dct8x8						=
COPY_devicequery				=
COPY_dotproduct					=
COPY_dxtcompression				=
COPY_fdtd3d						=
COPY_hiddenmarkovmodel			=
COPY_histogram					=
COPY_inlineptx					=
COPY_marchingcubes				=
COPY_matrixmul					=
COPY_matvecmul					=
COPY_mersennetwister			=
COPY_multithreads				=
COPY_nbody						=
COPY_particles					=
COPY_postprocessgl				=
COPY_quasirandomgenerator		=
COPY_radixsort					=
COPY_recursivegaussian			=
COPY_reduction					=
COPY_scan						=
COPY_simplegl					=
COPY_simplemultigpu				=
COPY_simpletexture3d			=
COPY_sobelfilter				=
COPY_sortingnetworks			=
COPY_transpose					=
COPY_tridiagonal				=
COPY_vectoradd					=
COPY_volumerender				=

endif

.PHONY:    
	all clean

all: \
	all_1 all_2 all_3

all_1: bandwidthtest blackscholes boxfilter convolutionseparable copycomputeoverlap dct8x8 devicequery	dotproduct dxtcompression fdtd3d hiddenmarkovmodel histogram				

all_2: inlineptx marchingcubes matrixmul matvecmul mersennetwister	multithreads nbody particles postprocessgl quasirandomgenerator radixsort recursivegaussian reduction				

all_3: scan simplegl simplemultigpu simpletexture3d sobelfilter sortingnetworks transpose tridiagonal vectoradd volumerender

# Create build folder is necessary))
mkdir:
	mkdir -p $(BUILD_FOLDER);

bandwidthtest_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBandwidthTest/)
	$(COPY_bandwidthtest) 			$(GLOBAL) 	$(CXX)	$(CFLAGS) 	$(CFLAGS_bandwidthtest)			$(INCLUDES_bandwidthtest)			$(SOURCES_bandwidthtest)			$(VALPARAM_bandwidthtest) 			$(KERNEL_bandwidthtest) 		-o $(BUILD_FOLDER)$(PREFIX)bandwidthtest$(EXTENSION) 

blackscholes_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBlackScholes/)
	$(COPY_blackscholes) 			$(GLOBAL) 	$(CXX)	$(CFLAGS)	$(CFLAGS_blackscholes)			$(INCLUDES_blackscholes)			$(SOURCES_blackscholes)				$(VALPARAM_blackscholes) 			$(KERNEL_blackscholes) 			-o $(BUILD_FOLDER)$(PREFIX)blackscholes$(EXTENSION) 

boxfilter_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBoxFilter/)
	$(COPY_boxfilter)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_boxfilter)				$(INCLDUES_boxfilter)				$(SOURCES_boxfilter)				$(VALPARAM_boxfilter)				$(KERNEL_boxfilter)				-o $(BUILD_FOLDER)$(PREFIX)boxfilter$(EXTENSION)

convolutionseparable_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_convolutionseparable)	$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_convolutionseparable)	$(INCLDUES_convolutionseparable)	$(SOURCES_convolutionseparable)		$(VALPARAM_convolutionseparable)	$(KERNEL_convolutionseparable)	-o $(BUILD_FOLDER)$(PREFIX)convolutionseparable$(EXTENSION)

copycomputeoverlap_sample: mkdir
	$(call chdirNVIDIA_GPU_Computing_SDK/OpenCL/src/,)
	$(COPY_copycomputeoverlap)		$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_copycomputeoverlap)	$(INCLDUES_copycomputeoverlap)		$(SOURCES_copycomputeoverlap)		$(VALPARAM_copycomputeoverlap)		$(KERNEL_copycomputeoverlap)	-o $(BUILD_FOLDER)$(PREFIX)copycomputeoverlap$(EXTENSION)	

dct8x8_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_dct8x8)					$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_dct8x8)				$(INCLDUES_dct8x8)					$(SOURCES_dct8x8)					$(VALPARAM_dct8x8)					$(KERNEL_dct8x8)				-o $(BUILD_FOLDER)$(PREFIX)dct8x8$(EXTENSION)	

devicequery_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_devicequery)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_devicequery)			$(INCLDUES_devicequery)				$(SOURCES_devicequery)				$(VALPARAM_devicequery)				$(KERNEL_devicequery)			-o $(BUILD_FOLDER)$(PREFIX)devicequery$(EXTENSION)	

dotproduct_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_dotproduct)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_dotproduct)			$(INCLDUES_dotproduct)				$(SOURCES_dotproduct)				$(VALPARAM_dotproduct)				$(KERNEL_dotproduct)			-o $(BUILD_FOLDER)$(PREFIX)dotproduct$(EXTENSION)	

dxtcompression_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_dxtcompression)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_dxtcompression)		$(INCLDUES_dxtcompression)			$(SOURCES_dxtcompression)			$(VALPARAM_dxtcompression)			$(KERNEL_dxtcompression)		-o $(BUILD_FOLDER)$(PREFIX)dxtcompression$(EXTENSION)	

fdtd3d_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_fdtd3d)					$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_fdtd3d)				$(INCLDUES_fdtd3d)					$(SOURCES_fdtd3d)					$(VALPARAM_fdtd3d)					$(KERNEL_fdtd3d)				-o $(BUILD_FOLDER)$(PREFIX)fdtd3d$(EXTENSION)	

hiddenmarkovmodel_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_hiddenmarkovmodel)		$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_hiddenmarkovmodel)		$(INCLDUES_hiddenmarkovmodel)		$(SOURCES_hiddenmarkovmodel)		$(VALPARAM_hiddenmarkovmodel)		$(KERNEL_hiddenmarkovmodel)		-o $(BUILD_FOLDER)$(PREFIX)hiddenmarkovmodel$(EXTENSION)

histogram_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_histogram)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_histogram)				$(INCLDUES_histogram)				$(SOURCES_histogram)				$(VALPARAM_histogram)				$(KERNEL_histogram)				-o $(BUILD_FOLDER)$(PREFIX)histogram$(EXTENSION)

inlineptx_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_inlineptx)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_inlineptx)				$(INCLDUES_inlineptx)				$(SOURCES_inlineptx)				$(VALPARAM_inlineptx)				$(KERNEL_inlineptx)				-o $(BUILD_FOLDER)$(PREFIX)inlineptx$(EXTENSION)

marchingcubes_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_marchingcubes)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_marchingcubes)			$(INCLDUES_marchingcubes)			$(SOURCES_marchingcubes)			$(VALPARAM_marchingcubes)			$(KERNEL_marchingcubes)			-o $(BUILD_FOLDER)$(PREFIX)marchingcubes$(EXTENSION)

matrixmul_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_matrixmul)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_matrixmul)				$(INCLDUES_matrixmul)				$(SOURCES_matrixmul)				$(VALPARAM_matrixmul)				$(KERNEL_matrixmul)				-o $(BUILD_FOLDER)$(PREFIX)matrixmul$(EXTENSION)

matvecmul_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_matvecmul)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_matvecmul)				$(INCLDUES_matvecmul)				$(SOURCES_matvecmul)				$(VALPARAM_matvecmul)				$(KERNEL_matvecmul)				-o $(BUILD_FOLDER)$(PREFIX)matvecmul$(EXTENSION)

mersennetwister_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_mersennetwister)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_mersennetwister)		$(INCLDUES_mersennetwister)			$(SOURCES_mersennetwister)			$(VALPARAM_mersennetwister)			$(KERNEL_mersennetwister)		-o $(BUILD_FOLDER)$(PREFIX)mersennetwister$(EXTENSION)	

multithreads_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_multithreads)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_multithreads)			$(INCLDUES_multithreads)			$(SOURCES_multithreads)				$(VALPARAM_multithreads)			$(KERNEL_multithreads)			-o $(BUILD_FOLDER)$(PREFIX)multithreads$(EXTENSION)

nbody_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_nbody)					$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_nbody)					$(INCLDUES_nbody)					$(SOURCES_nbody)					$(VALPARAM_nbody)					$(KERNEL_nbody)					-o $(BUILD_FOLDER)$(PREFIX)nbody$(EXTENSION)

particles_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_particles)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_particles)				$(INCLDUES_particles)				$(SOURCES_particles)				$(VALPARAM_particles)				$(KERNEL_particles)				-o $(BUILD_FOLDER)$(PREFIX)particles$(EXTENSION)

postprocessgl_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_postprocessgl)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_postprocessgl)			$(INCLDUES_postprocessgl)			$(SOURCES_postprocessgl)			$(VALPARAM_postprocessgl)			$(KERNEL_postprocessgl)			-o $(BUILD_FOLDER)$(PREFIX)postprocessgl$(EXTENSION)

quasirandomgenerator_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_quasirandomgenerator)	$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_quasirandomgenerator)	$(INCLDUES_quasirandomgenerator)	$(SOURCES_quasirandomgenerator)		$(VALPARAM_quasirandomgenerator)	$(KERNEL_quasirandomgenerator)	-o $(BUILD_FOLDER)$(PREFIX)quasirandomgenerator$(EXTENSION)

radixsort_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_radixsort)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_radixsort)				$(INCLDUES_radixsort)				$(SOURCES_radixsort)				$(VALPARAM_radixsort)				$(KERNEL_radixsort)				-o $(BUILD_FOLDER)$(PREFIX)radixsort$(EXTENSION)

recursivegaussian_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_recursivegaussian)		$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_recursivegaussian)		$(INCLDUES_recursivegaussian)		$(SOURCES_recursivegaussian)		$(VALPARAM_recursivegaussian)		$(KERNEL_recursivegaussian)		-o $(BUILD_FOLDER)$(PREFIX)recursivegaussian$(EXTENSION)

reduction_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_reduction)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_reduction)				$(INCLDUES_reduction)				$(SOURCES_reduction)				$(VALPARAM_reduction)				$(KERNEL_reduction)				-o $(BUILD_FOLDER)$(PREFIX)reduction$(EXTENSION)

scan_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_scan)					$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_scan)					$(INCLDUES_scan)					$(SOURCES_scan)						$(VALPARAM_scan)					$(KERNEL_scan)					-o $(BUILD_FOLDER)$(PREFIX)scan$(EXTENSION)

simplegl_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_simplegl)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_simplegl)				$(INCLDUES_simplegl)				$(SOURCES_simplegl)					$(VALPARAM_simplegl)				$(KERNEL_simplegl)				-o $(BUILD_FOLDER)$(PREFIX)simplegl$(EXTENSION)

simplemultigpu_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_simplemultigpu)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_simplemultigpu)		$(INCLDUES_simplemultigpu)			$(SOURCES_simplemultigpu)			$(VALPARAM_simplemultigpu)			$(KERNEL_simplemultigpu)		-o $(BUILD_FOLDER)$(PREFIX)simplemultigpu$(EXTENSION)	

simpletexture3d_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_simpletexture3d)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_simpletexture3d)		$(INCLDUES_simpletexture3d)			$(SOURCES_simpletexture3d)			$(VALPARAM_simpletexture3d)			$(KERNEL_simpletexture3d)		-o $(BUILD_FOLDER)$(PREFIX)simpletexture3d$(EXTENSION)	

sobelfilter_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_sobelfilter)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_sobelfilter)			$(INCLDUES_sobelfilter)				$(SOURCES_sobelfilter)				$(VALPARAM_sobelfilter)				$(KERNEL_sobelfilter)			-o $(BUILD_FOLDER)$(PREFIX)sobelfilter$(EXTENSION)	

sortingnetworks_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_sortingnetworks)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_sortingnetworks)		$(INCLDUES_sortingnetworks)			$(SOURCES_sortingnetworks)			$(VALPARAM_sortingnetworks)			$(KERNEL_sortingnetworks)		-o $(BUILD_FOLDER)$(PREFIX)sortingnetworks$(EXTENSION)	

transpose_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_transpose)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_transpose)				$(INCLDUES_transpose)				$(SOURCES_transpose)				$(VALPARAM_transpose)				$(KERNEL_transpose)				-o $(BUILD_FOLDER)$(PREFIX)transpose$(EXTENSION)

tridiagonal_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_tridiagonal)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_tridiagonal)			$(INCLDUES_tridiagonal)				$(SOURCES_tridiagonal)				$(VALPARAM_tridiagonal)				$(KERNEL_tridiagonal)			-o $(BUILD_FOLDER)$(PREFIX)tridiagonal$(EXTENSION)	

vectoradd_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_vectoradd)				$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_vectoradd)				$(INCLDUES_vectoradd)				$(SOURCES_vectoradd)				$(VALPARAM_vectoradd)				$(KERNEL_vectoradd)				-o $(BUILD_FOLDER)$(PREFIX)vectoradd$(EXTENSION)

volumerender_sample: mkdir
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/)
	$(COPY_volumerender)			$(GLOBAL)	$(CXX)	$(CFLAGS)	$(CFLAGS_volumerender)			$(INCLDUES_volumerender)			$(SOURCES_volumerender)				$(VALPARAM_volumerender)			$(KERNEL_volumerender)			-o $(BUILD_FOLDER)$(PREFIX)volumerender$(EXTENSION)

clean:
	rm -rf bin/
	mkdir -p bin/
	mkdir -p tmp/
	cp js/memoryprofiler.js tmp/ && cp js/settings.js tmp/ && cp js/index.html tmp/
	rm -rf js/
	mkdir js/
	cp tmp/memoryprofiler.js js/ && cp tmp/settings.js js/ && cp tmp/index.html js/
	rm -rf tmp/
	$(EMSCRIPTEN_ROOT)/emcc --clear-cache
	

# ifeq ($(NAT),1)
# oclBoxFilter_preload =
# else
# oclBoxFilter_preload = --preload-file BoxFilter.cl --preload-file data/lenaRGB.ppm
# endif
# oclBoxFilter_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBoxFilter/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclBoxFilter.$(EXTENSION) \
# 	$(common_part) \
# 	BoxFilterHost.cpp \
# 	oclBoxFilter.cpp \
# 	$(oclBoxFilter_preload)

# ifeq ($(NAT),1)
# oclConvolutionSeparable_preload =
# else
# oclConvolutionSeparable_preload = --preload-file ConvolutionSeparable.cl
# endif
# oclConvolutionSeparable_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclConvolutionSeparable/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclConvolutionSeparable.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclConvolutionSeparable_gold.cpp \
# 	src/oclConvolutionSeparable_launcher.cpp \
# 	$(oclConvolutionSeparable_preload)

# ifeq ($(NAT),1)
# oclCopyComputeOverlap_preload =
# else
# oclCopyComputeOverlap_preload = --preload-file VectorHypot.cl
# endif
# oclCopyComputeOverlap_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclCopyComputeOverlap/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclCopyComputeOverlap.$(EXTENSION) \
# 	$(common_part) \
# 	oclCopyComputeOverlap.cpp \
# 	$(oclCopyComputeOverlap_preload)	

# ifeq ($(NAT),1)
# oclDCT8x8_preload =
# else
# oclDCT8x8_preload = --preload-file DCT8x8.cl
# endif
# oclDCT8x8_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDCT8x8/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDCT8x8.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclDCT8x8_gold.cpp \
# 	src/oclDCT8x8_launcher.cpp \
# 	$(oclDCT8x8_preload)

# oclDeviceQuery_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDeviceQuery/)
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDeviceQuery.$(EXTENSION) \
# 	$(common_part) \
# 	oclDeviceQuery.cpp

# ifeq ($(NAT),1)
# oclDotProduct_preload =
# else
# oclDotProduct_preload = --preload-file DotProduct.cl
# endif
# oclDotProduct_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDotProduct/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDotProduct.$(EXTENSION) \
# 	$(common_part) \
# 	oclDotProduct.cpp \
# 	$(oclDotProduct_preload)	

# ifeq ($(NAT),1)
# oclDXTCompression_preload =
# else
# oclDXTCompression_preload = --preload-file DXTCompression.cl --preload-file data/lena_ref.dds --preload-file data/lena_std.ppm
# endif
# oclDXTCompression_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDXTCompression/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDXTCompression.$(EXTENSION) \
# 	$(common_part) \
# 	block.cpp \
# 	oclDXTCompression.cpp \
# 	$(oclDXTCompression_preload)	

# ifeq ($(NAT),1)
# oclFDTD3d_preload =
# else
# oclFDTD3d_preload = --preload-file FDTD3d.cl
# endif
# oclFDTD3d_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclFDTD3d/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclFDTD3d.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/FDTD3dGPU.cpp \
# 	src/FDTD3dReference.cpp \
# 	src/oclFDTD3d.cpp \
# 	$(oclFDTD3d_preload)	

# ifeq ($(NAT),1)
# oclHiddenMarkovModel_preload =
# else
# oclHiddenMarkovModel_preload = --preload-file Viterbi.cl
# endif
# oclHiddenMarkovModel_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclHiddenMarkovModel/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclHiddenMarkovModel.$(EXTENSION) \
# 	$(common_part) \
# 	HMM.cpp \
# 	oclHiddenMarkovModel.cpp \
# 	ViterbiCPU.cpp \
# 	$(oclHiddenMarkovModel_preload)	

# ifeq ($(NAT),1)
# oclHistogram_preload =
# else
# oclHistogram_preload = --preload-file Histogram64.cl --preload-file Histogram256.cl
# endif
# oclHistogram_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclHistogram/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclHistogram.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclHistogram_gold.cpp \
# 	src/oclHistogram64_launcher.cpp \
# 	src/oclHistogram256_launcher.cpp \
# 	$(oclHistogram_preload)

# ifeq ($(NAT),1)
# oclInlinePTX_preload =
# else
# oclInlinePTX_preload = --preload-file inlinePTX.cl
# endif
# oclInlinePTX_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclInlinePTX/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclInlinePTX.$(EXTENSION) \
# 	$(common_part) \
# 	oclInlinePTX.cpp \
# 	$(oclInlinePTX_preload)

# ifeq ($(NAT),1)
# oclMarchingCubes_preload =
# else
# oclMarchingCubes_preload = --preload-file marchingCubes_kernel.cl --preload-file Scan.cl --preload-file data/Bucky.raw
# endif
# oclMarchingCubes_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMarchingCubes/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMarchingCubes.$(EXTENSION) \
# 	$(common_part) \
# 	oclMarchingCubes.cpp \
# 	oclScan_launcher.cpp \
# 	$(oclMarchingCubes_preload)

# ifeq ($(NAT),1)
# oclMatrixMul_preload =
# else
# oclMatrixMul_preload = --preload-file matrixMul.cl  --preload-file matrixMul.hpp
# endif
# oclMatrixMul_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMatrixMul/)
# 	cp *.cl ../../../../build/out/
# 	cp matrixMul.hpp ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMatrixMul.$(EXTENSION) \
# 	$(common_part) \
# 	matrixMul_gold.cpp \
# 	oclMatrixMul.cpp \
# 	$(oclMatrixMul_preload)

# ifeq ($(NAT),1)
# oclMatVecMul_preload =
# else
# oclMatVecMul_preload = --preload-file oclMatVecMul.cl
# endif
# oclMatVecMul_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMatVecMul/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMatVecMul.$(EXTENSION) \
# 	$(common_part) \
# 	oclMatVecMul.cpp \
# 	$(oclMatVecMul_preload)

# ifeq ($(NAT),1)
# oclMersenneTwister_preload =
# else
# oclMersenneTwister_preload = --preload-file MersenneTwister.cl --preload-file data/MersenneTwister.dat --preload-file data/MersenneTwister.raw
# endif
# oclMersenneTwister_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMersenneTwister/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMersenneTwister.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/genmtrand.cpp \
# 	src/oclMersenneTwister_gold.cpp \
# 	src/oclMersenneTwister.cpp \
# 	$(oclMersenneTwister_preload)

# ifeq ($(NAT),1)
# oclMultiThreads_preload =
# else
# oclMultiThreads_preload = --preload-file kernel.cl
# endif
# oclMultiThreads_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMultiThreads/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMultiThreads.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	multithreading.cpp \
# 	oclMultiThreads.cpp \
# 	$(oclMultiThreads_preload)



# ifeq ($(NAT),1)
# oclNbody_preload =
# else
# oclNbody_preload = --preload-file oclNbodyKernel.cl
# endif
# oclNbody_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclNbody/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclNbody.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/oclBodySystemCpu.cpp \
# 	src/oclBodySystemOpencl.cpp \
# 	src/oclBodySystemOpenclLaunch.cpp \
# 	src/oclNbody.cpp \
# 	src/oclNbodyGold.cpp \
# 	src/oclRenderParticles.cpp \
# 	src/param.cpp \
# 	src/paramgl.cpp \
# 	$(oclNbody_preload)


# ifeq ($(NAT),1)
# oclParticles_preload = 
# else
# oclParticles_preload = 	--preload-file BitonicSort_b.cl --preload-file Particles.cl
# endif
# oclParticles_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclParticles/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclParticles.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclBitonicSort_launcher.cpp \
# 	src/oclManager.cpp \
# 	src/oclParticles_launcher.cpp \
# 	src/param.cpp \
# 	src/paramgl.cpp \
# 	src/particleSystem_class.cpp \
# 	src/particleSystemHost.cpp \
# 	src/render_particles.cpp \
# 	src/shaders.cpp \
# 	$(oclParticles_preload)

# ifeq ($(NAT),1)
# oclPostprocessGL_preload = 
# else
# oclPostprocessGL_preload = --preload-file PostprocessGL.cl
# endif
# oclPostprocessGL_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclPostprocessGL/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclPostprocessGL.$(EXTENSION) \
# 	$(common_part) \
# 	oclPostprocessGL.cpp \
# 	postprocessGL_Host.cpp \
# 	$(oclPostprocessGL_preload)

# ifeq ($(NAT),1)
# oclQuasirandomGenerator_preload = 
# else
# oclQuasirandomGenerator_preload = --preload-file QuasirandomGenerator.cl
# endif
# oclQuasirandomGenerator_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclQuasirandomGenerator/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclQuasirandomGenerator.$(EXTENSION) \
# 	$(common_part) \
# 	oclQuasirandomGenerator_gold.cpp \
# 	oclQuasirandomGenerator.cpp \
# 	$(oclQuasirandomGenerator_preload)

# ifeq ($(NAT),1)
# oclRadixSort_preload =
# else
# oclRadixSort_preload = --preload-file RadixSort.cl --preload-file Scan_b.cl
# endif
# oclRadixSort_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclRadixSort/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclRadixSort.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/oclRadixSort.cpp \
# 	src/RadixSort.cpp \
# 	src/Scan.cpp \
# 	$(oclRadixSort_preload)	

# ifeq ($(NAT),1)
# oclRecursiveGaussian_preload =
# else
# oclRecursiveGaussian_preload = --preload-file RecursiveGaussian.cl --preload-file data/StoneRGB.ppm
# endif
# oclRecursiveGaussian_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclRecursiveGaussian/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclRecursiveGaussian.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/oclRecursiveGaussian.cpp \
# 	src/RecursiveGaussianHost.cpp \
# 	$(oclRecursiveGaussian_preload)	

# ifeq ($(NAT),1)
# oclReduction_preload =
# else
# oclReduction_preload = --preload-file oclReduction_kernel.cl
# endif
# oclReduction_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclReduction/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclReduction.$(EXTENSION) \
# 	-I./ \
# 	$(common_part) \
# 	oclReduction.cpp \
# 	$(oclReduction_preload)	

# ifeq ($(NAT),1)
# oclScan_preload =
# else
# oclScan_preload = --preload-file Scan.cl
# endif
# oclScan_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclScan/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclScan.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclScan_gold.cpp \
# 	src/oclScan_launcher.cpp \
# 	$(oclScan_preload)	


# ifeq ($(NAT),1)
# oclSimpleGL_preload =
# else
# oclSimpleGL_preload = --preload-file simpleGL.cl
# endif
# oclSimpleGL_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleGL/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleGL.$(EXTENSION) \
# 	-Iinc/ \
# 	$(common_part) \
# 	oclSimpleGL.cpp \
# 	$(oclSimpleGL_preload)	

# ifeq ($(NAT),1)
# oclSimpleMultiGPU_preload =
# else
# oclSimpleMultiGPU_preload = --preload-file simpleMultiGPU.cl
# endif
# oclSimpleMultiGPU_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleMultiGPU/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleMultiGPU.$(EXTENSION) \
# 	$(common_part) \
# 	oclSimpleMultiGPU.cpp \
# 	$(oclSimpleMultiGPU_preload)	

# ifeq ($(NAT),1)
# oclSimpleTexture3D_preload =
# else
# oclSimpleTexture3D_preload = --preload-file oclSimpleTexture3D_kernel.cl --preload-file data/Bucky.raw --preload-file data/ref_simpleTex3D.ppm --preload-file data/ref_texture3D.bin
# endif
# oclSimpleTexture3D_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleTexture3D/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleTexture3D.$(EXTENSION) \
# 	$(common_part) \
# 	oclSimpleTexture3D.cpp \
# 	$(oclSimpleTexture3D_preload)	

# ifeq ($(NAT),1)
# oclSobelFilter_preload =
# else
# oclSobelFilter_preload = --preload-file SobelFilter.cl --preload-file data/StoneRGB.ppm
# endif
# oclSobelFilter_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSobelFilter/)
# 	cp *.cl ../../../../build/out/
# 	cp -R data/ ../../../../build/out/data/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSobelFilter.$(EXTENSION) \
# 	-I./ \
# 	$(common_part) \
# 	DeviceManager.cpp \
# 	oclSobelFilter.cpp \
# 	SobelFilterHost.cpp \
# 	$(oclSobelFilter_preload)	

# ifeq ($(NAT),1)
# oclSortingNetworks_preload =
# else
# oclSortingNetworks_preload = --preload-file BitonicSort.cl
# endif
# oclSortingNetworks_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSortingNetworks/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSortingNetworks.$(EXTENSION) \
# 	-I./src/ \
# 	$(common_part) \
# 	src/main.cpp \
# 	src/oclBitonicSort_launcher.cpp \
# 	src/oclSortingNetworks_validate.cpp \
# 	$(oclSortingNetworks_preload)	

# ifeq ($(NAT),1)
# oclTranspose_preload =
# else
# oclTranspose_preload = --preload-file transpose.cl
# endif
# oclTranspose_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclTranspose/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclTranspose.$(EXTENSION) \
# 	$(common_part) \
# 	oclTranspose.cpp \
# 	transpose_gold.cpp \
# 	$(oclTranspose_preload)	

# ifeq ($(NAT),1)
# oclTridiagonal_preload =
# else
# oclTridiagonal_preload = --preload-file cyclic_kernels.cl --preload-file pcr_kernels.cl --preload-file sweep_kernels.cl
# endif
# oclTridiagonal_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclTridiagonal/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclTridiagonal.$(EXTENSION) \
# 	-I./ \
# 	$(common_part) \
# 	oclTridiagonal.cpp \
# 	$(oclTridiagonal_preload)	

# ifeq ($(NAT),1)
# oclVectorAdd_preload =
# else
# oclVectorAdd_preload = --preload-file VectorAdd.cl
# endif
# oclVectorAdd_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclVectorAdd/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclVectorAdd.$(EXTENSION) \
# 	$(common_part) \
# 	oclVectorAdd.cpp \
# 	$(oclVectorAdd_preload)	

# ifeq ($(NAT),1)
# oclVolumeRender_preload =
# else
# oclVolumeRender_preload = --preload-file volumeRender.cl --preload-file data/Bucky.raw
# endif
# oclVolumeRender_sample:
# 	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclVolumeRender/)
# 	cp *.cl ../../../../build/out/
# 	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
# 	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclVolumeRender.$(EXTENSION) \
# 	$(common_part) \
# 	oclVolumeRender.cpp \
# 	$(oclVolumeRender_preload)	


