/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef NSTEMPERATUREL2_H
#define NSTEMPERATUREL2_H

#include "Kernel.h"
#include "Material.h"

//Forward Declarations
class NSTemperatureL2;

template<>
InputParameters validParams<NSTemperatureL2>();

/**
 * This class was originally used to solve for the temperature
 * using an L2-projection.  I'm not sure if anything is still
 * using this.  If not, it could probably be removed.
 */
class NSTemperatureL2 : public Kernel
{
public:

  NSTemperatureL2(const std::string & name, InputParameters parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  unsigned int _p_var;
  VariableValue & _p;

  unsigned int _pe_var;
  VariableValue & _pe;

  unsigned int _u_vel_var;
  VariableValue & _u_vel;

  unsigned int _v_vel_var;
  VariableValue & _v_vel;

  unsigned int _w_vel_var;
  VariableValue & _w_vel;

  const MaterialProperty<Real> & _c_v;
};

#endif
