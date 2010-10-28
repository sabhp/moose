[Mesh]
  [./Generation]
    dim = 2
    nx = 50
    ny = 50
    nz = 0
    
    xmax = 40
    ymax = 40
    zmax = 0
    elem_type = QUAD4
  [../]
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  active = 'diff forcing dot'

  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./forcing]
    type = GaussContForcing
    variable = u
    function = forcing_func
  [../]

  [./dot]
    type = TimeDerivative
    variable = u
  [../]
[]

[BCs]
  #active = ' '

  [./Periodic]
    [./x]
      type = DirichletBC
      variable = u
      primary = 3
      secondary = 1
      translation = '40 0 0'
    [../]

    [./y]
      type = DirichletBC
      variable = u
      primary = 0
      secondary = 2
      translation = '0 40 0'
    [../]
  [../]
[]

[Materials]
  active = empty

  [./empty]
    type = EmptyMaterial
    block = 0
  [../]
[]

[Executioner]
  type = Transient
  perf_log = true
  dt = 1
  num_steps = 20
[]

[Output]
  file_base = out
  interval = 1
  exodus = true
[]

