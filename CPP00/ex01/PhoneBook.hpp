#ifndef PHONEBOOK_HPP
# define PHONEBOOK_HPP
# include <iostream>
# include <iomanip>
# include "Contact.hpp"

# define MAXIMUM_CONTACTS 8
# define COLUMN_WIDTH 10

class	PhoneBook
{
	public:
		PhoneBook();
		~PhoneBook();
		void		addContact(void);
		void		searchContact(void);
	private:
		Contact		contacts[MAXIMUM_CONTACTS];
		int			contactIndex;
		int			contactCount;
		void		displayContactsTable(void);
		void		displayIndexedContact(void);
};

#endif