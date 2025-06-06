#ifndef Harl_HPP
# define Harl_HPP
# include <iostream>

class Harl
{
	public:
		Harl();
		~Harl();
		void	complain(std::string level);

	private:
		typedef	void				(Harl::*thought)(void);
		static const std::string	_levels[];
		static const thought		_thoughts[];

		int		getLevel(std::string);
		void	debug();
		void	info();
		void	warning();
		void	error();
};

#endif
