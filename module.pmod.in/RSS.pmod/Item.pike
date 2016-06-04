import Public.Parser.XML2;
import ".";

//!

  inherit Thing;

  string type = "Item";
  multiset element_subelements = (<"enclosure", "category", "guid",
                                   "title", "link", "author", "source",
                                   "pubDate", "comments", "description">);

  string render()
  {
    string d = "<item>\n";

    foreach(indices(data);;string e)
    {
      if(this_object()["render_" + e])
        d += call_function(this_object()["render_" + e]);
    }

    d += "</item>\n";

    return d;
  } 

  string render_guid()
  {
    if(data->guid)
      return "<guid " + (sizeof(data->guid)>1 ? 
        "isPermaLink=\"" + data->guid[1] + "\"":"") + "/>" + data->guid[0] + 
        "</guid>";
  }

  string render_description()
  {
    if(data->description)
      return "<description>" + data->description + "</description>";
  }

  string render_pubDate()
  {
    if(data->pubDate)
      return "<pubDate>" + data->pubDate + "</pubDate>";
  }

  string render_comments()
  {
    if(data->comments)
      return "<comments>" + data->comments + "</comments>";
  }

  string render_category()
  {
    string d = "";
    if(data->category)
      foreach(data->category;; array c)
        d += "<category domain=\"" + c[1] + "\">" + c[0] + "</category>";
    return d;
  }


  string render_title()
  {
    if(data->title)
      return "<title>" + data->title + "</title>";
  }

  string render_author()
  {
    if(data->author)
      return "<author>" + data->author + "</author>";
  }

  string render_link()
  {
    if(data->link)
      return "<link>" + data->link + "</link>";
  }

  protected void create(void|Node xml, void|string version)
  {
    ::create(xml, version);

    if(xml != UNDEFINED)     
      if(!(data["title"] || data["description"]))
        error("Incomplete " + type + " definition: title or description must be provided.\n");
  }

  void parse_enclosure(Node xml, string version)
  {
    mapping a = xml->get_attributes();

    if(!(a->url && a->length && a->type))
      error("Error in " + type + " definition: enclosure is malformed.\n");

    data->enclosure = ([ "url": a->url, "length": a->length, "type": a->type ]);

  }

//!
  void set_enclosure(string url, string length, string type)
  {
    data->enclosure = ([ "url": url, "length": length, "type": type ]);

  }

//! we can have more than one category.
  void add_category(string name, string domain)
  {    
    if(!data->category) data->category = ({});
    data->category = ({ ({name, domain}) });
  }

//!
  void set_source(string name, string url)
  {
    data->source = ([name: url]);
  }

//!
  void set_guid(string name, int(0..1) permalink)
  {
    data->guid = ([name: permalink]);
  }

//!
  void set_author(string author)
  {
    data->author = author;
  }

//!
  void set_comments(string comments)
  {
    data->comments = comments;
  }

//!
  void set_pubDate(string pubDate)
  {
    data->pubDate = pubDate;
  }

  void parse_source(Node xml, string version)
  {
    string e, v;

    mapping a = xml->get_attributes();
    if(!a["url"]) error("Error in Item: source must provide a url.\n");

    v = a["url"];
  
    e = get_element_text(xml);
    
    data->source = ([e: v]);
  }
  
  void parse_category(Node xml, string version)
  {
    string e, v;

    mapping a = xml->get_attributes();
    if(a["domain"]) v = a["domain"];

    e = get_element_text(xml);

    if(!data->category) data->category = ({});

    data->category += ({ ({e, v}) });
  }

  void parse_guid(Node xml, string version)
  {
    string e; int v;
    mapping a = xml->get_attributes();
    if(a["isPermaLink"]) v = 1;

    e = get_element_text(xml);

    data->guid = ({e, v});
    
  }

 void handle_ns_element_callback(string ns, string element, Node data, object thing)
 {
   function f = Public.Syndication.RSS.get_ns_item_handler(ns, element);

   if(f) f(ns, element, data, thing);
 }

