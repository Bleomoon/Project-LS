#ifndef _VALUATION_H_
#define _VALUATION_H_

#include "aexp.h"
#include <string>
#include <vector>

class valuation
{
	std::vector<std::pair<std::string, std::string>> variables;

public:
	valuation(const std::string& s, const std::string& value);
	void add(const std::string& s, const std::string& value);
	std::vector<std::pair<std::string, std::string>> getVariables();
};

#endif