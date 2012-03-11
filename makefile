
# This makefile is for creating a .tar.gz file containing files to hand in

NAME=Ekstrem-Multiprogrammering-2007-Anders-L-Thogersen

all: ./$(NAME).tar.gz

./$(NAME).tar.gz: ALWAYS
	rm -fr /tmp/$(NAME)
	cd kroc   && $(MAKE) clean
	cd report && $(MAKE) clean report.pdf && $(MAKE) distclean
	mkdir -p /tmp/$(NAME)/{kroc,report}
	cp -p  kroc/[a-z]*   /tmp/$(NAME)/kroc
	cp -p  report/[a-z]* /tmp/$(NAME)/report
	cp -p  README.md    /tmp/$(NAME)
	(cd /tmp && tar -cvzf $(NAME).tar.gz $(NAME) && cd - && mv /tmp/$(NAME).tar.gz . && rm -fr /tmp/$(NAME))

upload:
	ncftpput -f ~/private/b1-bladre.txt -R em $(NAME).tar.gz

clean:
	rm -fv $(NAME)*
	cd kroc && $(MAKE) clean
	cd report && $(MAKE) clean

ALWAYS:
