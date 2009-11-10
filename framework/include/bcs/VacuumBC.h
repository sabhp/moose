#ifndef VACUUMBC_H
#define VACUUMBC_H

#include "BoundaryCondition.h"


//Forward Declarations
class VacuumBC;

template<>
InputParameters valid_params<VacuumBC>();

/**
 * Implements a simple Vacuum BC for neutron diffusion on the boundary.
 * Vacuum BC is defined as \f$ D\frac{du}{dn}+\frac{u}{2} = 0\f$, where u is neutron flux.
 * Hence, \f$ D\frac{du}{dn}=-\frac{u}{2} \f$ and \f$ -\frac{u}{2} \f$ is substituted into 
 * the Neumann BC term produced from integrating the diffusion operator by parts.
 */
class VacuumBC : public BoundaryCondition
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  VacuumBC(std::string name, InputParameters parameters, std::string var_name, unsigned int boundary_id, std::vector<std::string> coupled_to, std::vector<std::string> coupled_as);

  virtual ~VacuumBC(){}

protected:
  virtual Real computeQpResidual();
  
  virtual Real computeQpJacobian();

private:
  /**
   * Ratio of u to du/dn
   */
  Real _alpha;
};

#endif //VACUUMBC_H
