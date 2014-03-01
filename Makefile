#
#  Makefile
#  Licence : https://github.com/wolfviking0/webcl-translator/blob/master/LICENSE
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

CURRENT_ROOT:=$(PWD)/

ORIG=0
ifeq ($(ORIG),1)
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../emscripten
else

$(info )
$(info )
$(info **************************************************************)
$(info **************************************************************)
$(info ************ /!\ BUILD USE SUBMODULE CARREFUL /!\ ************)
$(info **************************************************************)
$(info **************************************************************)
$(info )
$(info )

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../webcl-translator/emscripten
endif

CXX = $(EMSCRIPTEN_ROOT)/em++

CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

DEB=0
VAL=0
NAT=0
FAST=1

ifeq ($(VAL),1)
PREFIX = val_
VALIDATOR = '[""]' # Enable validator without parameter
$(info ************  Mode VALIDATOR : Enabled ************)
else
PREFIX = 
VALIDATOR = '[]' # disable validator
$(info ************  Mode VALIDATOR : Disabled ************)
endif

ifeq ($(NAT),1)
EXTENSION = out
DEBUG = -O0 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework IOKit -D__EMSCRIPTEN__ -DGPU_PROFILING -lGLEW
NO_DEBUG = -02 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework IOKit -D__EMSCRIPTEN__ -DGPU_PROFILING -lGLEW
CXX = clang++
CC = clang
BUILD_FOLDER = build/out/
$(info ************  Mode Native : Enabled ************)
else
EXTENSION = js
DEBUG = -O0 -s LEGACY_GL_EMULATION=1 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s CL_PRINT_TRACE=1 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1 -s TOTAL_MEMORY=1024*1024*750 -DGPU_PROFILING
NO_DEBUG = -02 -s LEGACY_GL_EMULATION=1 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=1 -s CL_PRINT_TRACE=0 -s CL_CHECK_VALID_OBJECT=0 -s TOTAL_MEMORY=1024*1024*750 -DGPU_PROFILING
CXX = $(EMSCRIPTEN_ROOT)/em++
CC = $(EMSCRIPTEN_ROOT)/emcc
BUILD_FOLDER = build/
$(info ************  Mode EMSCRIPTEN : Enabled ************)
endif

ifeq ($(DEB),1)
MODE=$(DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCC_DEBUG
$(info ************  Mode DEBUG : Enabled ************)
else
MODE=$(NO_DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCCDEBUG
$(info ************  Mode DEBUG : Disabled ************)
endif

$(info )
$(info )


#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#
# BUILD
#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#
common_part = \
	-I$(EMSCRIPTEN_ROOT)/system/include \
	-I../../common/inc \
	-I../../../shared/inc \
	../../common/src/oclUtils.cpp \
	../../../shared/src/cmd_arg_reader.cpp \
	../../../shared/src/shrUtils.cpp \

all: all_1 all_2 all_3

all_1: \
	oclBandwidthTest_sample \
	oclBlackScholes_sample \
	oclBoxFilter_sample \
	oclConvolutionSeparable_sample \
	oclCopyComputeOverlap_sample \
	oclDCT8x8_sample \
	oclDeviceQuery_sample \
	oclDotProduct_sample \
	oclDXTCompression_sample \
	oclFDTD3d_sample \
	oclHiddenMarkovModel_sample \

all_2: \
	oclHistogram_sample \
	oclInlinePTX_sample \
	oclMarchingCubes_sample \
	oclMatrixMul_sample \
	oclMatVecMul_sample \
	oclMersenneTwister_sample \
	oclMultiThreads_sample \
	oclNbody_sample \
	oclParticles_sample \
	oclPostprocessGL_sample \
	oclQuasirandomGenerator_sample \
	
all_3: \
	oclRadixSort_sample \
	oclRecursiveGaussian_sample \
	oclReduction_sample \
	oclScan_sample \
	oclSimpleGL_sample \
	oclSimpleMultiGPU_sample \
	oclSimpleTexture3D_sample \
	oclSobelFilter_sample \
	oclSortingNetworks_sample \
	oclTranspose_sample \
	oclTridiagonal_sample \
	oclVectorAdd_sample \
	oclVolumeRender_sample \

oclBandwidthTest_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBandwidthTest/)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclBandwidthTest.$(EXTENSION) \
	$(common_part) \
	oclBandwidthTest.cpp \

ifeq ($(NAT),1)
oclBlackScholes_preload =
else
oclBlackScholes_preload = --preload-file BlackScholes.cl
endif
oclBlackScholes_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBlackScholes/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclBlackScholes.$(EXTENSION) \
	$(common_part) \
	src/main.cpp \
	src/oclBlackScholes_gold.cpp \
	src/oclBlackScholes_launcher.cpp \
	$(oclBlackScholes_preload)

ifeq ($(NAT),1)
oclBoxFilter_preload =
else
oclBoxFilter_preload = --preload-file BoxFilter.cl --preload-file data/lenaRGB.ppm
endif
oclBoxFilter_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclBoxFilter/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclBoxFilter.$(EXTENSION) \
	$(common_part) \
	BoxFilterHost.cpp \
	oclBoxFilter.cpp \
	$(oclBoxFilter_preload)

ifeq ($(NAT),1)
oclConvolutionSeparable_preload =
else
oclConvolutionSeparable_preload = --preload-file ConvolutionSeparable.cl
endif
oclConvolutionSeparable_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclConvolutionSeparable/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclConvolutionSeparable.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/main.cpp \
	src/oclConvolutionSeparable_gold.cpp \
	src/oclConvolutionSeparable_launcher.cpp \
	$(oclConvolutionSeparable_preload)

ifeq ($(NAT),1)
oclCopyComputeOverlap_preload =
else
oclCopyComputeOverlap_preload = --preload-file VectorHypot.cl
endif
oclCopyComputeOverlap_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclCopyComputeOverlap/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclCopyComputeOverlap.$(EXTENSION) \
	$(common_part) \
	oclCopyComputeOverlap.cpp \
	$(oclCopyComputeOverlap_preload)	

ifeq ($(NAT),1)
oclDCT8x8_preload =
else
oclDCT8x8_preload = --preload-file DCT8x8.cl
endif
oclDCT8x8_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDCT8x8/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDCT8x8.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/main.cpp \
	src/oclDCT8x8_gold.cpp \
	src/oclDCT8x8_launcher.cpp \
	$(oclDCT8x8_preload)

oclDeviceQuery_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDeviceQuery/)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDeviceQuery.$(EXTENSION) \
	$(common_part) \
	oclDeviceQuery.cpp

ifeq ($(NAT),1)
oclDotProduct_preload =
else
oclDotProduct_preload = --preload-file DotProduct.cl
endif
oclDotProduct_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDotProduct/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDotProduct.$(EXTENSION) \
	$(common_part) \
	oclDotProduct.cpp \
	$(oclDotProduct_preload)	

ifeq ($(NAT),1)
oclDXTCompression_preload =
else
oclDXTCompression_preload = --preload-file DXTCompression.cl --preload-file data/lena_ref.dds --preload-file data/lena_std.ppm
endif
oclDXTCompression_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclDXTCompression/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclDXTCompression.$(EXTENSION) \
	$(common_part) \
	block.cpp \
	oclDXTCompression.cpp \
	$(oclDXTCompression_preload)	

ifeq ($(NAT),1)
oclFDTD3d_preload =
else
oclFDTD3d_preload = --preload-file FDTD3d.cl
endif
oclFDTD3d_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclFDTD3d/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclFDTD3d.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/FDTD3dGPU.cpp \
	src/FDTD3dReference.cpp \
	src/oclFDTD3d.cpp \
	$(oclFDTD3d_preload)	

ifeq ($(NAT),1)
oclHiddenMarkovModel_preload =
else
oclHiddenMarkovModel_preload = --preload-file Viterbi.cl
endif
oclHiddenMarkovModel_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclHiddenMarkovModel/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclHiddenMarkovModel.$(EXTENSION) \
	$(common_part) \
	HMM.cpp \
	oclHiddenMarkovModel.cpp \
	ViterbiCPU.cpp \
	$(oclHiddenMarkovModel_preload)	

ifeq ($(NAT),1)
oclHistogram_preload =
else
oclHistogram_preload = --preload-file Histogram64.cl --preload-file Histogram256.cl
endif
oclHistogram_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclHistogram/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclHistogram.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/main.cpp \
	src/oclHistogram_gold.cpp \
	src/oclHistogram64_launcher.cpp \
	src/oclHistogram256_launcher.cpp \
	$(oclHistogram_preload)

ifeq ($(NAT),1)
oclInlinePTX_preload =
else
oclInlinePTX_preload = --preload-file inlinePTX.cl
endif
oclInlinePTX_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclInlinePTX/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclInlinePTX.$(EXTENSION) \
	$(common_part) \
	oclInlinePTX.cpp \
	$(oclInlinePTX_preload)

ifeq ($(NAT),1)
oclMarchingCubes_preload =
else
oclMarchingCubes_preload = --preload-file marchingCubes_kernel.cl --preload-file Scan.cl --preload-file data/Bucky.raw
endif
oclMarchingCubes_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMarchingCubes/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMarchingCubes.$(EXTENSION) \
	$(common_part) \
	oclMarchingCubes.cpp \
	oclScan_launcher.cpp \
	$(oclMarchingCubes_preload)

ifeq ($(NAT),1)
oclMatrixMul_preload =
else
oclMatrixMul_preload = --preload-file matrixMul.cl  --preload-file matrixMul.hpp
endif
oclMatrixMul_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMatrixMul/)
	cp *.cl ../../../../build/out/
	cp matrixMul.hpp ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMatrixMul.$(EXTENSION) \
	$(common_part) \
	matrixMul_gold.cpp \
	oclMatrixMul.cpp \
	$(oclMatrixMul_preload)

ifeq ($(NAT),1)
oclMatVecMul_preload =
else
oclMatVecMul_preload = --preload-file oclMatVecMul.cl
endif
oclMatVecMul_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMatVecMul/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMatVecMul.$(EXTENSION) \
	$(common_part) \
	oclMatVecMul.cpp \
	$(oclMatVecMul_preload)

ifeq ($(NAT),1)
oclMersenneTwister_preload =
else
oclMersenneTwister_preload = --preload-file MersenneTwister.cl --preload-file data/MersenneTwister.dat --preload-file data/MersenneTwister.raw
endif
oclMersenneTwister_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMersenneTwister/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMersenneTwister.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/genmtrand.cpp \
	src/oclMersenneTwister_gold.cpp \
	src/oclMersenneTwister.cpp \
	$(oclMersenneTwister_preload)

ifeq ($(NAT),1)
oclMultiThreads_preload =
else
oclMultiThreads_preload = --preload-file kernel.cl
endif
oclMultiThreads_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclMultiThreads/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclMultiThreads.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	multithreading.cpp \
	oclMultiThreads.cpp \
	$(oclMultiThreads_preload)



ifeq ($(NAT),1)
oclNbody_preload =
else
oclNbody_preload = --preload-file oclNbodyKernel.cl
endif
oclNbody_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclNbody/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclNbody.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/oclBodySystemCpu.cpp \
	src/oclBodySystemOpencl.cpp \
	src/oclBodySystemOpenclLaunch.cpp \
	src/oclNbody.cpp \
	src/oclNbodyGold.cpp \
	src/oclRenderParticles.cpp \
	src/param.cpp \
	src/paramgl.cpp \
	$(oclNbody_preload)


ifeq ($(NAT),1)
oclParticles_preload = 
else
oclParticles_preload = 	--preload-file BitonicSort_b.cl --preload-file Particles.cl
endif
oclParticles_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclParticles/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclParticles.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/main.cpp \
	src/oclBitonicSort_launcher.cpp \
	src/oclManager.cpp \
	src/oclParticles_launcher.cpp \
	src/param.cpp \
	src/paramgl.cpp \
	src/particleSystem_class.cpp \
	src/particleSystemHost.cpp \
	src/render_particles.cpp \
	src/shaders.cpp \
	$(oclParticles_preload)

ifeq ($(NAT),1)
oclPostprocessGL_preload = 
else
oclPostprocessGL_preload = --preload-file PostprocessGL.cl
endif
oclPostprocessGL_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclPostprocessGL/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclPostprocessGL.$(EXTENSION) \
	$(common_part) \
	oclPostprocessGL.cpp \
	postprocessGL_Host.cpp \
	$(oclPostprocessGL_preload)

ifeq ($(NAT),1)
oclQuasirandomGenerator_preload = 
else
oclQuasirandomGenerator_preload = --preload-file QuasirandomGenerator.cl
endif
oclQuasirandomGenerator_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclQuasirandomGenerator/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclQuasirandomGenerator.$(EXTENSION) \
	$(common_part) \
	oclQuasirandomGenerator_gold.cpp \
	oclQuasirandomGenerator.cpp \
	$(oclQuasirandomGenerator_preload)

ifeq ($(NAT),1)
oclRadixSort_preload =
else
oclRadixSort_preload = --preload-file RadixSort.cl --preload-file Scan_b.cl
endif
oclRadixSort_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclRadixSort/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclRadixSort.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/oclRadixSort.cpp \
	src/RadixSort.cpp \
	src/Scan.cpp \
	$(oclRadixSort_preload)	

ifeq ($(NAT),1)
oclRecursiveGaussian_preload =
else
oclRecursiveGaussian_preload = --preload-file RecursiveGaussian.cl --preload-file data/StoneRGB.ppm
endif
oclRecursiveGaussian_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclRecursiveGaussian/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclRecursiveGaussian.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/oclRecursiveGaussian.cpp \
	src/RecursiveGaussianHost.cpp \
	$(oclRecursiveGaussian_preload)	

ifeq ($(NAT),1)
oclReduction_preload =
else
oclReduction_preload = --preload-file oclReduction_kernel.cl
endif
oclReduction_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclReduction/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclReduction.$(EXTENSION) \
	-I./ \
	$(common_part) \
	oclReduction.cpp \
	$(oclReduction_preload)	

ifeq ($(NAT),1)
oclScan_preload =
else
oclScan_preload = --preload-file Scan.cl
endif
oclScan_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclScan/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclScan.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	src/main.cpp \
	src/oclScan_gold.cpp \
	src/oclScan_launcher.cpp \
	$(oclScan_preload)	


ifeq ($(NAT),1)
oclSimpleGL_preload =
else
oclSimpleGL_preload = --preload-file simpleGL.cl
endif
oclSimpleGL_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleGL/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleGL.$(EXTENSION) \
	-Iinc/ \
	$(common_part) \
	oclSimpleGL.cpp \
	$(oclSimpleGL_preload)	

ifeq ($(NAT),1)
oclSimpleMultiGPU_preload =
else
oclSimpleMultiGPU_preload = --preload-file simpleMultiGPU.cl
endif
oclSimpleMultiGPU_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleMultiGPU/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleMultiGPU.$(EXTENSION) \
	$(common_part) \
	oclSimpleMultiGPU.cpp \
	$(oclSimpleMultiGPU_preload)	

ifeq ($(NAT),1)
oclSimpleTexture3D_preload =
else
oclSimpleTexture3D_preload = --preload-file oclSimpleTexture3D_kernel.cl --preload-file data/Bucky.raw --preload-file data/ref_simpleTex3D.ppm --preload-file data/ref_texture3D.bin
endif
oclSimpleTexture3D_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSimpleTexture3D/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSimpleTexture3D.$(EXTENSION) \
	$(common_part) \
	oclSimpleTexture3D.cpp \
	$(oclSimpleTexture3D_preload)	

ifeq ($(NAT),1)
oclSobelFilter_preload =
else
oclSobelFilter_preload = --preload-file SobelFilter.cl --preload-file data/StoneRGB.ppm
endif
oclSobelFilter_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSobelFilter/)
	cp *.cl ../../../../build/out/
	cp -R data/ ../../../../build/out/data/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSobelFilter.$(EXTENSION) \
	-I./ \
	$(common_part) \
	DeviceManager.cpp \
	oclSobelFilter.cpp \
	SobelFilterHost.cpp \
	$(oclSobelFilter_preload)	

ifeq ($(NAT),1)
oclSortingNetworks_preload =
else
oclSortingNetworks_preload = --preload-file BitonicSort.cl
endif
oclSortingNetworks_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclSortingNetworks/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclSortingNetworks.$(EXTENSION) \
	-I./src/ \
	$(common_part) \
	src/main.cpp \
	src/oclBitonicSort_launcher.cpp \
	src/oclSortingNetworks_validate.cpp \
	$(oclSortingNetworks_preload)	

ifeq ($(NAT),1)
oclTranspose_preload =
else
oclTranspose_preload = --preload-file transpose.cl
endif
oclTranspose_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclTranspose/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclTranspose.$(EXTENSION) \
	$(common_part) \
	oclTranspose.cpp \
	transpose_gold.cpp \
	$(oclTranspose_preload)	

ifeq ($(NAT),1)
oclTridiagonal_preload =
else
oclTridiagonal_preload = --preload-file cyclic_kernels.cl --preload-file pcr_kernels.cl --preload-file sweep_kernels.cl
endif
oclTridiagonal_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclTridiagonal/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclTridiagonal.$(EXTENSION) \
	-I./ \
	$(common_part) \
	oclTridiagonal.cpp \
	$(oclTridiagonal_preload)	

ifeq ($(NAT),1)
oclVectorAdd_preload =
else
oclVectorAdd_preload = --preload-file VectorAdd.cl
endif
oclVectorAdd_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclVectorAdd/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclVectorAdd.$(EXTENSION) \
	$(common_part) \
	oclVectorAdd.cpp \
	$(oclVectorAdd_preload)	

ifeq ($(NAT),1)
oclVolumeRender_preload =
else
oclVolumeRender_preload = --preload-file volumeRender.cl --preload-file data/Bucky.raw
endif
oclVolumeRender_sample:
	$(call chdir,NVIDIA_GPU_Computing_SDK/OpenCL/src/oclVolumeRender/)
	cp *.cl ../../../../build/out/
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(MODE) \
	-o ../../../../$(BUILD_FOLDER)/$(PREFIX)oclVolumeRender.$(EXTENSION) \
	$(common_part) \
	oclVolumeRender.cpp \
	$(oclVolumeRender_preload)	



clean:
	$(call chdir,build/)
	rm -rf tmp/	
	mkdir tmp
	rm -rf out/	
	mkdir out
	cp memoryprofiler.js tmp/
	cp settings.js tmp/
	rm -f *.data
	rm -f *.js
	rm -f *.map
	cp tmp/memoryprofiler.js ./
	cp tmp/settings.js ./
	rm -rf tmp/
	$(CXX) --clear-cache

	
	
