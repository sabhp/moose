/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef NSENTHALPYAUX_H
#define NSENTHALPYAUX_H

#include "AuxKernel.h"

//Forward Declarations
class NSEnthalpyAux;

template<>
InputParameters validParams<NSEnthalpyAux>();

/**
 * Nodal auxiliary variable, for computing enthalpy at the nodes.
 * The total enthalpy is given by:
 *
 * H = E + p/rho (primitive variables)
 * H = (U_4 + P(U)) / U_0 (conserved variables)
 *
 * where P(U) = (gamma-1)*(U_4 - (1/2)*(U_1^2 + U_2^2 + U_3^2)/U_0)
 * is the pressure.
 */
class NSEnthalpyAux : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  NSEnthalpyAux(const std::string & name, InputParameters parameters);

  virtual ~NSEnthalpyAux() {}

protected:
  virtual Real computeValue();

  VariableValue & _rho;
  VariableValue & _rhoe;
  VariableValue & _pressure;

  Real _gamma;
};

#endif // NSENTHALPYAUX_H
