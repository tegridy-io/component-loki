local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();

// The hiera parameters for the component
local params = inv.parameters.loki;

// Values Files
local components = com.makeMergeable({
  querier: {
    [if params.components.querier.replicas > 1 then 'maxUnavailable']: 1,
  } + com.makeMergeable(params.components.querier),
  queryFrontend: {

  } + com.makeMergeable(params.components.queryFrontend),
  distributor: {

  } + com.makeMergeable(params.components.distributor),
  ingester: {
    [if params.components.ingester.replicas > 1 then 'maxUnavailable']: 1,
  } + com.makeMergeable(params.components.ingester),
  compactor: {

  } + com.makeMergeable(params.components.compactor),
  gateway: {

  } + com.makeMergeable(params.components.gateway),
});

// Caches
local optional = com.makeMergeable({
}) + com.makeMergeable(params.optional);

// Optional components
local caches = com.makeMergeable({
  memcachedExporter: {

  } + com.makeMergeable(params.caches.exporter),
  memcachedChunks: {

  } + com.makeMergeable(params.caches.chunks),
  memcachedFrontend: {

  } + com.makeMergeable(params.caches.frontend),
  memcachedIndexQueries: {

  } + com.makeMergeable(params.caches.indexQueries),
  memcachedIndexWrites: {

  } + com.makeMergeable(params.caches.indexWrites),
});


{
  ['%s-components' % inv.parameters._instance]: components + optional + caches,
  //   ['%s-configs' % inv.parameters._instance]: loki + bucket + haTracker,
  ['%s-overrides' % inv.parameters._instance]: params.helmValues,
}
