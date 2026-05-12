all:
	mkdir -p /home/login/data/wordpress /home/login/data/mariadb
	cd srcs && docker compose up -d --build

down:
	cd srcs && docker compose down

re: fclean all

clean:
	cd srcs && docker compose down -v

fclean: clean
	docker system prune -af
	sudo rm -rf /home/login/data

.PHONY: all down re clean fclean