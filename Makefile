build:
	@sudo docker build -t="docker-munin" .

run:
	@sudo docker run -d docker-munin
	@echo "Ports mapping:"
	@sudo docker ps | grep "docker-munin" | grep -o -P "\d*->\d*"
