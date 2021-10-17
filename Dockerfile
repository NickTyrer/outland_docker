FROM nicktyrer/outland_base:latest
COPY setup.sh /
COPY start.sh /
RUN chmod +x setup.sh start.sh
RUN /setup.sh
CMD ["/start.sh"]
