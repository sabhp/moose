/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef INTERACTIONINTEGRAL_H
#define INTERACTIONINTEGRAL_H

#include "ElementIntegralPostprocessor.h"
#include "CrackFrontDefinition.h"
#include "SymmTensor.h"

//Forward Declarations
class InteractionIntegral;

template<>
InputParameters validParams<InteractionIntegral>();

/**
 * This postprocessor computes the Interaction Integral
 *
 */
class InteractionIntegral: public ElementIntegralPostprocessor
{
public:
  InteractionIntegral(const std::string & name, InputParameters parameters);

  virtual Real getValue();

protected:
  virtual void initialSetup();
  virtual Real computeQpIntegral();
  /// The gradient of the scalar q field
  VariableGradient & _grad_of_scalar_q;
  const CrackFrontDefinition * const _crack_front_definition;
  bool _has_crack_front_point_index;
  const unsigned int _crack_front_point_index;
  bool _treat_as_2d;
  const MaterialProperty<ColumnMajorMatrix> & _Eshelby_tensor;
  const MaterialProperty<SymmTensor> & _stress;
  const MaterialProperty<SymmTensor> & _strain;
  VariableGradient & _grad_disp_x;
  VariableGradient & _grad_disp_y;
  VariableGradient & _grad_disp_z;
  std::string _aux_stress_name;
  const MaterialProperty<ColumnMajorMatrix> & _aux_stress;
  std::string _aux_grad_disp_name;
  const MaterialProperty<ColumnMajorMatrix> & _aux_grad_disp;
  Real _K_factor;
  bool _has_symmetry_plane;
  bool _t_stress;
  Real _poissons_ratio;
};

#endif //INTERACTIONINTEGRAL_H
