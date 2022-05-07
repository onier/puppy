et(visp_LIBRARIES)
find_library(visp_LIBRARIES
	        NAMES
		        visp_core
			        HINTS
				        ${OSS_PREFIX_LIB_PATH}
					        )

					find_path(visp_INCLUDE_DIRS
						        NAMES
							        visp3/visp.h
								        HINTS
									        ${OSS_PREFIX_INC_PATH}
										        )
										if (${visp_LIBRARIES} STREQUAL "visp_LIBRARIES-NOTFOUND" OR ${visp_INCLUDE_DIRS} STREQUAL "visp_INCLUDE_DIRS-NOTFOUND")
											    set(visp_FOUND OFF)
											        set(visp_LIBRARIES)
												    set(visp_INCLUDE_DIR)
											    else ()
												        set(visp_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
													    set(visp_LIBRARIES ${OSS_PREFIX_PATH}/lib/libvisp_ar.so
														                ${OSS_PREFIX_PATH}/lib/libvisp_blob.so
																            ${OSS_PREFIX_PATH}/lib/libvisp_core.so
																	                ${OSS_PREFIX_PATH}/lib/libvisp_detection.so
																			            ${OSS_PREFIX_PATH}/lib/libvisp_gui.so
																				                ${OSS_PREFIX_PATH}/lib/libvisp_imgproc.so
																						            ${OSS_PREFIX_PATH}/lib/libvisp_io.so
																							                ${OSS_PREFIX_PATH}/lib/libvisp_klt.so
																									            ${OSS_PREFIX_PATH}/lib/libvisp_mbt.so
																										                ${OSS_PREFIX_PATH}/lib/libvisp_me.so
																												            ${OSS_PREFIX_PATH}/lib/libvisp_robot.so
																													                ${OSS_PREFIX_PATH}/lib/libvisp_sensor.so
																															            ${OSS_PREFIX_PATH}/lib/libvisp_tt_mi.so
																																                ${OSS_PREFIX_PATH}/lib/libvisp_tt.so
																																		            ${OSS_PREFIX_PATH}/lib/libvisp_vision.so
																																			                ${OSS_PREFIX_PATH}/lib/libvisp_visual_features.so
																																					            ${OSS_PREFIX_PATH}/lib/libvisp_vs.so
																																						                )
																																							    set(visp_FOUND ON)
																																						    endif ()

