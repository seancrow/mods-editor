cocoon.load("resource://org/apache/cocoon/forms/flow/javascript/Form.js");

function modsxml(form) {
    // get the documentURI parameter from the sitemap which contains the
    // location of the file to be edited
    var documentURI = cocoon.parameters["documentURI"];
//		cocoon.log.info('dapisam: documentURI: ' + documentURI);

   	var document = loadDocument(documentURI); 
	 // note: this is a Java Document (http://java.sun.com/j2se/1.4.2/docs/api/org/w3c/dom/Document.html)


	  form.load(document);

    form.showForm("mods-display-pipeline", {document: document});
	cocoon.log.info('Starting saving document');
    form.save(document);
	cocoon.log.info('Finished saving document');
		cocoon.sendPage("mods-success-pipeline", {document: document});
}

function saveLastSubmitter(event) {
	element = event.source;
	form = element.getForm();
	lastSubmitter = element.id;
	//cocoon.log.info("lastSubmitter 0: lastSubmitter=" + lastSubmitter);
	// determine action type from name of lastSubmitter:
	//   might be insertWidget, deleteWidget, addWidget, moveUp, moveDown
	if (lastSubmitter == 'moveUp')
		{ action = 'moveUp'; }
	else if (lastSubmitter == 'moveDown')
		{ action = 'moveDown'; }
	else if (lastSubmitter.substring(0, 6) == 'insert')
		{ action = 'insert'; }
	else if (lastSubmitter.substring(0, 3) == 'add')
		{ action = 'add'; }
	else if (lastSubmitter.substring(0, 6) == 'delete')
		{ action = 'delete'; }
	else { action = 'unknown'; }

	// track whether we've picked up the number of the parent element
	// e.g. if the final id is originInfos.0.places.0.placeterms.0.authority,
	// the first number is the 0 before 'authority'
	gotFirstNumber = false;
	
	while (element.getParent().id != '') {
		//cocoon.log.info("lastSubmitter 1: id=" + element.getParent().id);
		element = element.getParent();
		if (!(gotFirstNumber)) {
			// we should have the number of the parent of the submitter
			eid = element.id * 1;
			//cocoon.log.info("eid: " + eid.toString());
			if (eid == -1) {
				// the action must be delete, so let's go for the ancestor of 
				// of the lastSubmitte
				lastSubmitter = "";
			}
			else if (action == 'insert') {
				// we want to get the new element, not the old one from which the
				// insertion was triggered
				eid++;
				lastSubmitter = eid.toString() + "." + lastSubmitter;
			}
			else {
				lastSubmitter = eid + "." + lastSubmitter;
			}
			gotFirstNumber = true;
		}
		else {
			lastSubmitter = element.id + "." + lastSubmitter;
		}
		// might end with period, if we had a -1
		//cocoon.log.info("lastSubmitter final period? [" + lastSubmitter.substring(lastSubmitter.length-1) + "]");
		if (lastSubmitter.substring(lastSubmitter.length-1) == ".") {
			//cocoon.log.info("lastSubmitter: truncating");
			lastSubmitter = lastSubmitter.substring(0, lastSubmitter.length-2);
		}
		
		// but for now, for deletions, we'll just go with the top-level element
		if (action == 'delete') {
			p = lastSubmitter.indexOf('.');
			//cocoon.log.info("lastSubmitter=" + lastSubmitter + " indexOf(.): " + p);
			if (p != -1) {			
				lastSubmitter = lastSubmitter.substring(0, p-1);
			}
			// we now have the first element of the id
			// FIXME: make it get the appropriate nested repeater, not the 
			// top-level element repeater.	the problem is that in the HTML, we
			// don't have ids like originInfos.0.blah.3.blah for divs, unless we write
			// logic in the template to produce them.
		}
		
		
		cocoon.log.info("lastSubmitter 2: lastSubmitter=" + lastSubmitter);
	}
	// we now have the element id in a form like this:
	// originInfos.0.dates.-1.deleteWidget
	// note that if we just deleted something, we get a -1
	// so truncate before this
		
	form.getChild("lastSubmitter").value = lastSubmitter;
	cocoon.log.info("dapisam test " + lastSubmitter);
}

function loadDocument(uri) {
    var parser = null;
    var source = null;
    var resolver = null;
    try {
        parser = cocoon.getComponent(Packages.org.apache.excalibur.xml.dom.DOMParser.ROLE);
        resolver = cocoon.getComponent(Packages.org.apache.cocoon.environment.SourceResolver.ROLE);
        source = resolver.resolveURI(uri);
        var is = new Packages.org.xml.sax.InputSource(source.getInputStream());
        is.setSystemId(source.getURI());
        return parser.parseDocument(is);
    } finally {
        if (source != null)
            resolver.release(source);
        cocoon.releaseComponent(parser);
        cocoon.releaseComponent(resolver);
    }
}



