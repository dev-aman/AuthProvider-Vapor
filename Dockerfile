# ================================
# Build image
# ================================
FROM vapor/swift:latest as build
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused 
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

# Compile with optimizations
RUN echo "swift build start"
RUN swift build \
	--enable-test-discovery \
	-c release \
	-Xswiftc -g
RUN echo "swift build end"

# ================================
# Run image
# ================================
FROM vapor/ubuntu:18.04
WORKDIR /run

# Copy build artifacts
COPY --from=build /build/.build/release /run
# Copy Swift runtime libraries
COPY --from=build /usr/lib/swift/ /usr/lib/swift/
# Uncomment the next line if you need to load resources from the `Public` directory
#COPY --from=build /build/Public /run/Public

ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0"]
