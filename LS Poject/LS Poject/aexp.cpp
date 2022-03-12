#include "aexp.h"

//put leaf to null and char to value
aexp::aexp(char ope)
{
	this->ope = ope;
	this->lLeaf = nullptr;
	this->rLeaf = nullptr;
}

aexp::~aexp()
{
	delete this->rLeaf;
	delete this->lLeaf;
}

aexp aexp::operator+(const aexp& exp) {
	std::cout << " an operator for axep + axep has not been decided yet, returned current expression" << std::endl;
	return *this;
}

void aexp::addLLeaf(const char ope, const char val) {
	char cpy = this->ope;
	this->addLLeaf = new aexp();
}

void aexp::addRLeaf(const char ope, const char val) {

}

char aexp::getRoot() {

}

char aexp::getLLeaf() {

}

char aexp::getRLeaf() {

}

std::ostream& operator<<(std::ostream& os, const aexp& exp) {
	
	for (int i = 0; i < exp.expr.size(); i++) {
		if (i == 0) {
			os << exp.expr.at(i);
		}
		else {
			os << " " << exp.expr.at(i);
		}
	}
	os << std::endl;
	return os;
}