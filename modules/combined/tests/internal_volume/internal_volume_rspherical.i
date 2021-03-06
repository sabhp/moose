#
# Internal Volume Test
#
# This test is designed to compute the internal volume of a space considering
#   an embedded volume inside.
#
# The mesh is composed of two blocks with an interior cavity of volume 3.
#   The volume of each of the blocks is also 3.  The volume of the entire sphere
#   is 9.
#

[Problem]
  coord_type = RSPHERICAL
[]

[Mesh]#Comment
  file = internal_volume_rspherical.e
  construct_side_list_from_node_list = true
[]

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = 1e4
  [../]
[]

[Variables]

  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

[]

[SolidMechanics]
  [./solid]
    disp_r = disp_x
  [../]
[]


[BCs]

  [./no_x]
    type = DirichletBC
    variable = disp_x
    boundary = '1 2 3 4'
    value = 0.0
  [../]

[]

[Materials]
  [./stiffStuff]
    type = Elastic
    block = 1

    disp_r = disp_x

    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]

  [./stiffStuff3]
    type = Elastic
    block = 3

    disp_r = disp_x

    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]
[]

[Executioner]

  type = Transient

  solve_type = PJFNK



  nl_abs_tol = 1e-10

  l_max_its = 20

  start_time = 0.0
  dt = 1.0
  end_time = 1.0
[]

[Postprocessors]
  [./internalVolume]
    type = InternalVolume
    boundary = 10
    component = 0
    execute_on = 'initial timestep_end'
  [../]
  [./intVol1]
    type = InternalVolume
    boundary = 2
    component = 0
    execute_on = 'initial timestep_end'
  [../]
  [./intVol1Again]
    type = InternalVolume
    boundary = 9
    component = 0
    execute_on = 'initial timestep_end'
  [../]
  [./intVol2]
    type = InternalVolume
    boundary = 11
    component = 0
    execute_on = 'initial timestep_end'
  [../]
  [./intVolTotal]
    type = InternalVolume
    boundary = 4
    component = 0
    execute_on = 'initial timestep_end'
  [../]
[]

[Outputs]
  output_initial = true
  exodus = true
  csv = true
  print_linear_residuals = true
  print_perf_log = true
[]
