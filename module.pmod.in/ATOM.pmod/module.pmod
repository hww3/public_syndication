constant __author = "James Tyson <jamesotron@helicopter.geek.nz>";
constant __version = "0.1";

//! Parser and renderer for W3C Atom 1.0 feeds.

#if !constant(Public.Parser.XML2)
throw(({ "This module depends on Public.Parser.XMl2, please install it with monger.\nCheck http://module.gotpike.org/ for more information.\n\n", backtrace() }));
#elif !constant(Public.Web.XHTML)
throw(({ "This module depends on Public.Web.XHTML, please install it with monger.\nCheck http://module.gotpike.org/ for more information.\n\n", backtrace() }));
#else

import Public.Parser;
import Standards;
import Protocols;

constant CONTENT_TYPE = "application/atom+xml";
constant XMLNS = "http://www.w3.org/2005/Atom";
constant MAJOR = 0;
constant MINOR = 1;
constant TEST = #string "test.xml";

static int _redirect_count;

//! Parse an ATOM feed from an XML string.
//!
//! @param xml
//!   a string containing an XML document.
//!
//! @returns
//!   an ATOM.Feed or ATOM.Entry object.
//!
.Feed|.Entry parse_atom_string(string xml) {
  return parse_atom(XML2.parse_xml(xml));
}

//! Retrieve an ATOM XML feed via HTTP
//! parse it and pass the Feed or Entry object
//! back to the callback.
//!
//! @param uri
//!   a Standards.URI object containing the URI of the Atom feed.
//!
//! @param feed_callback
//!   a function(void|Public.Web.ATOM.Feed|Public.Web.Atom.Entry atom) callback.
//!
//! @param heads
//!   any extra headers to be passed to the remote web server.
//!
void fetch_atom_http(URI uri, function feed_callback, void|mapping heads) {
  if (uri->scheme != "http")
    throw(({ "Can only retrieve ATOM feeds via HTTP at this time (get it yourself).\n", backtrace() }));
  if (!heads)
    heads = ([]);
  if (!heads["user-agent"])
    heads["user-agent"] = 
      sprintf("Protocols.Web.ATOM %d.%d (%s), http://modules.gotpike.org/blahblah/Protocols.Web.ATOM", 
	  MAJOR, MINOR, version());
  heads->host = uri->host;
  
  HTTP.Query query = HTTP.Query();
  query->set_callbacks(http_ok, http_fail, feed_callback, heads);
  query->async_request(uri->host, uri->port, sprintf("GET %s HTTP/1.1", uri->path), heads);
}

//!
static void http_ok(HTTP.Query query, function feed_callback, mapping heads) {
  write("status = %O\n", query->status);
  if ((query->status == 302) && (_redirect_count < 15)) {
    // Redirect.
    if (query->headers["set-cookie"])
      heads->cookie += query->headers["set-cookie"]*"";
    _redirect_count++;
    fetch_atom_http(URI(query->headers->location), feed_callback, heads);
  }
  else {
    _redirect_count = 0;
    /* Ignore this.  A lot of sites are broken and just return "application/xml" or worse.
    if (query->headers["content-type"] != CONTENT_TYPE)
      // Maybe should throw an error?
      feed_callback();
    else
    */
    feed_callback(parse_atom_string(query->data()));
  }
}

//!
static void http_fail(HTTP.Query query, function feed_callback, mapping heads) {
  if ((query->status == 302) && (_redirect_count < 15)) {
    // Redirect.
    if (query->headers["set-cookie"])
      heads->cookie += query->headers["set-cookie"]*"";
    _redirect_count++;
    fetch_atom_http(URI(query->headers->location), feed_callback, heads);
  }
  else {
    _redirect_count = 0;
    feed_callback();
  }
}


//! Parse an ATOM XML feed or entry in XML2 node format.
//!
//! @param xml
//!   a Public.Parser.XML2.Node containing an Atom feed or Entry.
//!
//! @returns
//!   an ATOM.Feed or ATOM.Entry object.
//!
.Feed|.Entry parse_atom(XML2.Node xml) {
  if ((xml->get_node_type() == 1) &&  /* Use XML2.Constants dummy */
      (xml->get_ns() == XMLNS)) {
    if (xml->get_node_name() == "feed") {
      return .Feed(xml);
    }
    else if (xml->get_node_name() == "entry") {
      return .Entry(xml);
    }
    else
      throw(({ "XML document is neither an ATOM feed or entry.", backtrace() }));
  }
} 

//! Render an ATOM feed or entry into an XML document.
//!
//! @param atom
//!   an ATOM.Feed or ATOM.Entry object.
//!
//! @returns
//!   an XML2.Node object.
//!
XML2.Node render_atom(.Feed|.Entry atom) {
  return atom->render();
}

//! Render an ATOM feed or entry into an XML document string.
//! 
//! @param atom
//!   an ATOM.Feed or ATOM.Entry object.
//! 
//! @returns
//!   a string containing an XML document.
//!
string render_atom_string(.Feed|.Entry atom) {
  return XML2.render_xml(render_atom(atom));
}

#endif
