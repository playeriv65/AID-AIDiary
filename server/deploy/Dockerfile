# Runtime image around a binary built elsewhere:
#   GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o deploy/aid-sync ./cmd/aid-sync
# Saves pulling the Go toolchain onto a small server.
FROM gcr.io/distroless/static-debian12:nonroot
COPY --chmod=0755 aid-sync /aid-sync
ENV AID_SYNC_DATA=/data AID_SYNC_ADDR=:8080
VOLUME /data
EXPOSE 8080
ENTRYPOINT ["/aid-sync"]
CMD ["serve"]
