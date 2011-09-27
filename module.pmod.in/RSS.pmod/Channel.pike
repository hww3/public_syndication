import Public.Parser.XML2;
import ".";
//!
  
  inherit Thing;
  
  string type = "Channel";

  multiset element_required_elements = (<"title", "link", "description">);
  multiset element_subelements = (<"title", "link", "description", "source",
                                   "image", "cloud", "category", "item", "language", "copyright">);

//!
  array(Item) items = ({});

  void create(Node|void xml, void|string _version)
  {
    if(_version=="1.0") {
      element_required_elements += (< "items">);
      element_subelements += (< "items", "textinput">);
    }
    else if(_version=="2.0" || _version=="0.92") {
      element_subelements += (< "item", "lastBuildDate", "lastBuildDate",
				   "managingEditor", "copyright",
				   "lastBuildDate", "language", "pubDate",
				   "generator", "docs", "ttl", "image",
				   "rating", "textInput", "skipHours",
                                   "skipDays", "webMaster" >);
    }
    else if(_version=="0.91") element_subelements += (< "item", "language" >);

    // next, we should look for channels.
    foreach(xml->children(); int index; Node child)
    {
      if(child->get_node_name() == "channel")
      {
        ::create(child, version);
        create(child, version);
      }

    }

  }

  function parse_textInput = parse_textinput;

//!
  void add_item(Item i)
  {
    items += ({ i });
  }

  void parse_textinput(Node xml, string version)
  {
    mapping d = ([]);

    multiset required_elements = (<"title", "description", "name", "link">);
    foreach(xml->children() || ({}); int index; Node child)
    {
       if(child && child->get_node_type() == Public.Parser.XML2.Constants.ELEMENT_NODE && required_elements[child->get_node_name()])
         d[child->get_node_name()] = get_element_text(child);
    }
    if(!(d->link && d->name && d->description && d->title))
    {
       error("textInput missing required elements\n");
    } 

    if(! data->textInput)
      data->textInput = ({});

    data->textInput += ({ d });
  }

  void parse_items(Node xml, string version)
  {
  }

  void parse_category(Node xml, string version)
  {
    string e, v;

    mapping a = xml->get_attributes();
    if(a["domain"]) v = a["domain"];

        e = xml->get_text();

    if(!data->category) data->category = ({});
    
    data->category+=({ ([e: v]) });
  }

//!
  void add_category(string category, string description)
  {
    if(!data->category) data->category = ({});
    
    data->category+=({ ([category: description]) });
  }

  void parse_image(Node xml, string version)
  {
  }

  void parse_language(Node xml, string version)
  {
    data->language = get_element_text(xml);
  }

  void parse_cloud(Node xml, string version)
  {

    mapping a = xml->get_attributes();

    if(!(a->domain && a->port && a->path && a->registerProcedure))
      error("Error in " + type + " definition: cloud is malformed.\n");

//    if(!data->cloud) data->cloud = ({});
  
    data->cloud = ([ "domain": a->domain, "port": a->port, "path": a->path, 
                         "registerProcedure": a->registerProcedure ]);

  }

//!
  void set_cloud(string domain, string port, string path, string reg)
  {
//    if(!data->cloud) data->cloud = ({});
  
    data->cloud = ([ "domain": domain, "port": port, "path": path, 
                         "registerProcedure": reg ]);
  }

  void parse_item(Node xml, string version)
  {
    items += ({ Item(xml, version) });
  }

 void handle_ns_element_callback(string ns, string element, Node data, object thing)
 {
   function f = Public.Syndication.RSS.get_ns_channel_handler(ns, element);

   if(f) f(ns, element, data, thing);
 }
