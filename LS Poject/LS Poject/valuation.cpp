#include "valuation.h"

valuation::valuation(const std::string& s, const std::string& value){
	this->variables.push_back(std::make_pair(s, value));
}

void valuation::add(const std::string& s, const std::string& value) {
	this->variables.push_back(std::make_pair(s, value));
}

std::vector<std::pair<std::string, std::string>> valuation::getVariables() {
	return this->variables;
}
