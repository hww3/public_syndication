constant __author = "Bill Welliver <hww3@riverweb.com>";
constant __version = "1.0";

//! This is a parser for RSS files. Versions 0.92, 1.0 and 2.0 are 
//! supported.

import Public.Parser.XML2;
constant V10_NS = "http://purl.org/rss/1.0/";

static mapping ns_channel_handlers = ([]);
static mapping ns_item_handlers = ([]);

//!
.Channel parse(string xml)
{
  string version;
  Node rss_node;
  Node n = parse_xml(xml);

//  if(n->get_node_type() != XML_ROOT) error("invalid XML provided!\n");

  // we should look at the children; one of them must be the RSS element
  do
  {
    if(n->get_node_name() == "rss")
    {
      // eureka! we have found RSS! let's make sure it's a valid version...
      if(n->get_attributes()["version"])
      {
        version=n->get_attributes()["version"];
        rss_node=n;
        break;
      }    
    }

    if(n->get_node_name() == "RDF" && n->get_nss()["_default"] && 
          n->get_nss()["_default"]== V10_NS)
    {
      // eureka! we have found RSS 1.0! let's make sure it's a valid version...
      version="1.0";
      rss_node=n;
        break;
    }
    n = n->next();
  } while(n);
  
  if(!rss_node) error("no rss element present!\n");

  return .Channel(rss_node, version);

}

//!  @param handler
//!   receives a function that gets the namespace, the element name, node and the Thing object
void add_ns_item_handler(string namespace, string element, function handler)
{
  if(!ns_item_handlers[namespace])
    ns_item_handlers[namespace] = ([]);
  ns_item_handlers[namespace][element] = handler;
}

//! @param handler
//!   receives a function that gets the namespace, the element name, node and the Thing object
void add_ns_channel_handler(string namespace, string element, function handler)
{
  if(!ns_channel_handlers[namespace])
    ns_channel_handlers[namespace] = ([]);
  ns_channel_handlers[namespace][element] = handler;
}

function get_ns_channel_handler(string ns, string element)
{
  function f;

  if(ns_channel_handlers[ns] && (f = ns_channel_handlers[ns][element]))
    return f;
  else return 0;
}

function get_ns_item_handler(string ns, string element)
{
  function f;

  if(ns_item_handlers[ns] && (f = ns_item_handlers[ns][element]))
    return f;
  else return 0;
}

