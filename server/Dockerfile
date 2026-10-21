# AID Diary sync server. Pure Go (SQLite through modernc.org/sqlite), so the
# binary is static and the image needs no libc.
FROM golang:1.26 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /aid-sync ./cmd/aid-sync

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /aid-sync /aid-sync
ENV AID_SYNC_DATA=/data AID_SYNC_ADDR=:8080
VOLUME /data
EXPOSE 8080
ENTRYPOINT ["/aid-sync"]
CMD ["serve"]
