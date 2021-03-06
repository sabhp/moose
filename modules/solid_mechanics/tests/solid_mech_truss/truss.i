#
# Truss
#
# The truss is made of five equilateral triangles supported at each end.
# The truss starts at (0,0).  At (1,0), there is a point load of 25.
# The reactions are therefore
#  Ryleft  = 2/3 * 25 = 16.7
#  Ryright = 1/3 * 25 = 8.33
# The area of each member is 0.8.
# Statics gives the stress in each member.  For example, for element 6 (from
#   (0,0) to (1/2,sqrt(3)/2)), the force is
#   f = 2/3 * 25 * 2/sqrt(3) = 100/3/sqrt(3) (compressive)
#   and the stress is
#   s = -100/3/sqrt(3)/0.8 = -24.06
#

[Mesh]
  type = FileMesh
  file = truss.e
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./axial_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e_over_l]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./area]
    order = CONSTANT
    family = MONOMIAL
#    initial_condition = 1.0
  [../]
  [./react_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./react_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./react_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Functions]
  [./x2]
    type = PiecewiseLinear
    x = '0  1 2 3'
    y = '0 .5 1 1'
  [../]
  [./y2]
    type = PiecewiseLinear
    x = '0 1  2 3'
    y = '0 0 .5 1'
  [../]
[]

[BCs]
  [./fixx1]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]
  [./fixy1]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0
  [../]
  [./fixz1]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0
  [../]


  [./fixy4]
    type = DirichletBC
    variable = disp_y
    boundary = 4
    value = 0
  [../]

  [./fixDummyHex_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1000
    value = 0
  [../]

  [./fixDummyHex_y]
    type = DirichletBC
    variable = disp_y
    boundary = 1000
    value = 0
  [../]

  [./fixDummyHex_z]
    type = DirichletBC
    variable = disp_z
    boundary = 1000
    value = 0
  [../]
[]

[DiracKernels]
  [./pull]
    type = ConstantPointSource
    value = -25
    point = '1 0 0'
    variable = disp_y
  [../]
[]

[AuxKernels]
  [./axial_stress]
    type = MaterialRealAux
    block = 1
    property = axial_stress
    variable = axial_stress
  [../]
  [./e_over_l]
    type = MaterialRealAux
    block = 1
    property = e_over_l
    variable = e_over_l
  [../]
  [./area]
    type = ConstantAux
    block = 1
    variable = area
    value = 0.8
    execute_on = 'initial timestep_begin'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK

  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'jacobi   101'

  nl_max_its = 15
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10

  dt = 1
  num_steps = 1
  end_time = 1
[]

[Kernels]
  [./solid_x]
    type = StressDivergenceTruss
    block = 1
    variable = disp_x
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    component = 0
    area = area
    save_in = react_x
  [../]
  [./solid_y]
    type = StressDivergenceTruss
    block = 1
    variable = disp_y
    component = 1
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    area = area
    save_in = react_y
  [../]
  [./solid_z]
    type = StressDivergenceTruss
    block = 1
    variable = disp_z
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    component = 2
    area = area
    save_in = react_z
  [../]
[]

[SolidMechanics]
#  [./solid]
#    type = truss
#    disp_x = disp_x
#    disp_y = disp_y
#    disp_z = disp_z
#    area = area
#    save_in = react_x
#    save_in = react_y
#    save_in = react_z
#  [../]
  [./dummyHex]
    block = 1000
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Materials]
  [./goo]
    type = Elastic
    block = 1000
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    youngs_modulus = 1e6
    poissons_ratio = 0
  [../]
  [./linelast]
    type = TrussMaterial
    block = 1
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    youngs_modulus = 1e6
  [../]
[]

[Outputs]
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
