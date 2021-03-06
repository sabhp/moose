/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "NodalVolumeFraction.h"
#include <cmath>

template<>
InputParameters validParams<NodalVolumeFraction>()
{
  InputParameters params = validParams<FeatureFloodCount>();
  params.addRequiredParam<PostprocessorName>("mesh_volume", "Postprocessor from which to get mesh volume");
  params.addParam<FileName>("Avrami_file", "filename for Avrami analysis info (ln time and Avrami)");
  params.addParam<Real>("equil_fraction", -1.0, "Equilibrium volume fraction of 2nd phase for Avrami analysis");

  return params;
}

NodalVolumeFraction::NodalVolumeFraction(const std::string & name, InputParameters parameters) :
    FeatureFloodCount(name, parameters),
    _mesh_volume(getPostprocessorValue("mesh_volume")),
    _equil_fraction(getParam<Real>("equil_fraction"))
{
  if (parameters.isParamValid("Avrami_file") && _equil_fraction < 0.0)
    mooseError("please supply an equilibrium fraction of 2nd phase for Avrami analysis (NodalVolumeFraction).");
}

NodalVolumeFraction::~NodalVolumeFraction()
{
}

void
NodalVolumeFraction::finalize()
{
  FeatureFloodCount::finalize();

  // If the bubble volume calculation wasn't done yet, do now.
  if (_all_bubble_volumes.empty())
    FeatureFloodCount::calculateBubbleVolumes();
  calculateBubbleFraction();

  // Now calculate the Avrami data if requested
  if (_pars.isParamValid("Avrami_file"))
  {
    // Output the headers during the first timestep
    if (_fe_problem.timeStep() == 0)
    {
      std::vector<std::string> data; data.reserve(4);
      data.push_back("timestep");
      data.push_back("time");
      data.push_back("log_time");
      data.push_back("Avrami");
      writeCSVFile(getParam<FileName>("Avrami_file"), data);
    }
    else
    {
      std::vector<Real> data; data.reserve(4);
      data.push_back(_fe_problem.timeStep());
      data.push_back(_fe_problem.time());
      data.push_back(std::log(_fe_problem.time()));
      data.push_back(calculateAvramiValue());
      writeCSVFile(getParam<FileName>("Avrami_file"), data);
    }
  }
}

Real
NodalVolumeFraction::getValue()
{
  return _volume_fraction;
}

void
NodalVolumeFraction::calculateBubbleFraction()
{
  Real volume(0.0);

  //sum the values in the vector to get total volume
  for (std::vector<Real>::const_iterator it = _all_bubble_volumes.begin(); it != _all_bubble_volumes.end(); ++it)
  {
    volume += *it;
  }

  _volume_fraction = volume/_mesh_volume;
}

Real
NodalVolumeFraction::calculateAvramiValue()
{
  return std::log(std::log(1.0/(1.0 - (_volume_fraction/_equil_fraction) ) ) );
}
