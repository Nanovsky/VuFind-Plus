<?php
/**
 * Table Definition for EContentRecord
 */
require_once 'DB/DataObject.php';
require_once 'DB/DataObject/Cast.php';

class EContentRecord extends DB_DataObject{
	public $__table = 'econtent_record';		// table name
	public $id;											//int(25)
	public $cover;										//varchar(255)
	public $title;
	public $subTitle;
	public $author;
	public $author2;
	public $description;
	public $contents;
	public $subject;
	public $language;
	public $publisher;
	public $publishDate;
	public $publishLocation;
	public $physicalDescription;
	public $edition;
	public $isbn;
	public $issn;
	public $upc;
	public $lccn;
	public $series;
	public $topic;
	public $genre;
	public $region;
	public $era;
	public $target_audience;
	public $date_added;
	public $date_updated;
	public $notes;
	public $ilsId;
	public $source;
	public $sourceUrl;
	public $externalId; //An external id for use in systems like OverDrive, 3M, etc.
	public $purchaseUrl;
	public $addedBy; //Id of the user who added the record or -1 for imported
	public $reviewedBy; //Id of a cataloging use who reviewed the item for consistency
	public $reviewStatus; //0 = unreviewed, 1=approved, 2=rejected
	public $reviewNotes;
	public $accessType;
	public $itemLevelOwnership;
	public $availableCopies;
	public $onOrderCopies;
	public $trialTitle;
	public $marcControlField;
	public $collection;
	public $literary_form_full;
	public $status; //'active', 'archived', or 'deleted'

	/* Static get */
	function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('EContentRecord',$k,$v); }

	function keys() {
		return array('id', 'filename');
	}

	function cores(){
		return array('econtent');
	}

	function recordtype(){
		return 'econtentRecord';
	}
	function getSolrId(){
		return $this->recordtype() . $this->id;
	}
	function title(){
		return $this->title;
	}
	function format_category(){
		global $configArray;

		$formats = $this->format();
		$formatCategory = null;
		$formatCategoryMap = $this->getFormatCategoryMap();
		foreach ($formats as $format){
			$format = str_replace(' ', '_', $format);
			if (array_key_exists($format, $formatCategoryMap)){
				$formatCategory = $formatCategoryMap[$format];
				break;
			}
		}
		if ($formatCategory == null){
			if (array_key_exists("*", $formatCategoryMap)){
				$formatCategory = $formatCategoryMap['*'];
			}else{
				if(isset($configArray['EContent']['formatCategory'])){
					return $configArray['EContent']['formatCategory'];
				}else{
					return 'EMedia';
				}
			}
		}
		return $formatCategory;
	}

	function getObjectStructure(){
		global $configArray;
		$structure = array(
		'id' => array(
			'property'=>'id',
			'type'=>'hidden',
			'label'=>'Id',
			'primaryKey'=>true,
			'description'=>'The unique id of the e-pub file.',
			'storeDb' => true,
		),

		'institution' => array(
			'property'=>'institution',
			'type'=>'method',
			'methodName'=>'institution',
			'storeDb' => false,
		),
		'building' => array(
			'property'=>'building',
			'type'=>'method',
			'methodName'=>'building',
			'storeDb' => false,
		),
		'title' => array(
			'property' => 'title',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>255,
			'label' => 'Title',
			'description' => 'The title of the item.',
			'required'=> true,
			'storeDb' => true,
		),
		'author' => array(
			'property' => 'author',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Author',
			'description' => 'The primary author of the item or editor if the title is a compilation of other works.',
			'required'=> false,
			'storeDb' => true,
		),
		'status' => array(
			'property' => 'status',
			'type' => 'enum',
			'values' => array('active' => 'Active', 'archived' => 'Archived', 'deleted' => 'Deleted'),
			'label' => 'Status',
			'description' => 'The Current Status of the record.',
			'required'=> true,
			'storeDb' => true,
		),
		'accessType' => array(
			'property'=>'accessType',
			'type'=>'enum',
			'values' => EContentRecord::getValidAccessTypes(),
			'label'=>'Access Type',
			'description'=>'The type of access control to apply to the record.',
			'storeDb' => true,
		),
		'itemLevelOwnership' => array(
			'property'=>'itemLevelOwnership',
			'type'=>'checkbox',
			'label'=>'Item Level Ownership (yes for most external links, no for other types)',
			'description'=>'Whether or not item ownership is determined at the item level (certain libraries have access to specific links) or at the record level (all items can be accessed based on ownership rules).',
			'storeDb' => true,
		),
		'availableCopies' => array(
			'property'=>'availableCopies',
			'type'=>'integer',
			'label'=>'Available Copies',
			'description'=>'The number of copies that have been purchased and are available to patrons.',
			'storeDb' => true,
		),
		'onOrderCopies' => array(
			'property'=>'onOrderCopies',
			'type'=>'integer',
			'label'=>'Copies On Order',
			'description'=>'The number of copies that have been purchased but are not available for usage yet.',
			'storeDb' => true,
		),
		'trialTitle' => array(
			'property' => 'trialTitle',
			'type' => 'checkbox',
			'label' => "Trial Title",
			'description' => 'Whether or not the title was loaded on a trial basis or if it is a premanent acquisition.',
			'storeDb' => true,
		),
		'cover' => array(
			'property' => 'cover',
			'type' => 'image',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'cover',
			'description' => 'The cover of the item.',
			'storagePath' => $configArray['Site']['coverPath'] . '/original',
			'required'=> false,
			'storeDb' => true,
		),
		'language' => array(
			'property' => 'language',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Language',
			'description' => 'The Language of the item.',
			'required'=> true,
			'storeDb' => true,
		),
		'literary_form_full' => array(
			'property' => 'literary_form_full',
			'label' => 'Literary Form',
			'description' => 'The Literary Form of the item.',
			'type' => 'enum',
			'values' => array(
				'' => 'Unknown',
				'Fiction' => 'Fiction',
				'Non Fiction' => 'Non Fiction',
				'Novels' => 'Novels',
				'Short Stories' => 'Short Stories',
				'Poetry' => 'Poetry',
				'Dramas' => 'Dramas',
				'Essays' => 'Essays',
				'Mixed Forms' => 'Mixed Forms',
				'Humor, Satires, etc.' => 'Humor, Satires, etc.',
				'Speeches' => 'Speeches',
				'Letters' => 'Letters',
			),
			'storeDb' => true,
		),
		'author2' => array(
			'property' => 'author2',
			'type' => 'crSeparated',
			'label' => 'Additional Authors',
			'rows'=>3,
			'cols'=>80,
			'description' => 'The Additional Authors of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'description' => array(
			'property' => 'description',
			'type' => 'textarea',
			'label' => 'Description',
			'rows'=>3,
			'cols'=>80,
			'description' => 'A brief description of the file for indexing and display if there is not an existing record within the catalog.',
			'required'=> false,
			'storeDb' => true,
		),
		'contents' => array(
			'property' => 'contents',
			'type' => 'textarea',
			'label' => 'Table of Contents',
			'rows'=>3,
			'cols'=>80,
			'description' => 'The table of contents for the record.',
			'required'=> false,
			'storeDb' => true,
		),
		'econtentText' => array(
			'property' => 'econtentText',
			'type' => 'method',
			'label' => 'Full text of the eContent',
			'storeDb' => false,
		),
		'subject' => array(
			'property' => 'subject',
			'type' => 'crSeparated',
			'label' => 'Subject',
			'rows'=>3,
			'cols'=>80,
			'description' => 'The Subject of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'publisher' => array(
			'property' => 'publisher',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Publisher',
			'description' => 'The Publisher of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'publishDate' => array(
			'property' => 'publishDate',
			'type' => 'integer',
			'size' => 4,
			'maxLength' => 4,
			'label' => 'Publication Year',
			'description' => 'The year the title was published.',
			'required'=> false,
			'storeDb' => true,
		),
		'publishLocation' => array(
			'property' => 'publishLocation',
			'type' => 'text',
			'size' => 100,
			'maxLength' => 100,
			'label' => 'Publication Location',
			'description' => 'Where the title was published.',
			'required'=> false,
			'storeDb' => true,
		),
		'physicalDescription' => array(
			'property' => 'physicalDescription',
			'type' => 'text',
			'size' => 100,
			'maxLength' => 100,
			'label' => 'Physical Description',
			'description' => 'A description of the title (number of pages, etc).',
			'required'=> false,
			'storeDb' => true,
		),

		'edition' => array(
			'property' => 'edition',
			'type' => 'crSeparated',
			'rows'=>2,
			'cols'=>80,
			'label' => 'Edition',
			'description' => 'The Edition of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'isbn' => array(
			'property' => 'isbn',
			'type' => 'crSeparated',
			'rows'=>1,
			'cols'=>80,
			'label' => 'isbn',
			'description' => 'The isbn of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'issn' => array(
			'property' => 'issn',
			'type' => 'crSeparated',
			'rows'=>1,
			'cols'=>80,
			'label' => 'issn',
			'description' => 'The issn of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'upc' => array(
			'property' => 'upc',
			'type' => 'crSeparated',
			'rows'=>1,
			'cols'=>80,
			'label' => 'upc',
			'description' => 'The upc of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'lccn' => array(
			'property' => 'lccn',
			'type' => 'crSeparated',
			'rows'=>1,
			'cols'=>80,
			'label' => 'lccn',
			'description' => 'The lccn of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'series' => array(
			'property' => 'series',
			'type' => 'crSeparated',
			'rows'=>3,
			'cols'=>80,
			'label' => 'series',
			'description' => 'The Series of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'topic' => array(
			'property' => 'topic',
			'type' => 'crSeparated',
			'rows'=>3,
			'cols'=>80,
			'label' => 'Topic',
			'description' => 'The Topic of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'genre' => array(
			'property' => 'genre',
			'type' => 'crSeparated',
			'rows'=>3,
			'cols'=>80,
			'label' => 'Genre',
			'description' => 'The Genre of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'region' => array(
			'property' => 'region',
			'type' => 'crSeparated',
			'rows'=>3,
			'cols'=>80,
			'label' => 'Region',
			'description' => 'The Region of the item.',
			'required'=> false,
			'storeDb' => true,
		),

		'era' => array(
			'property' => 'era',
			'type' => 'crSeparated',
			'rows'=>3,
			'cols'=>80,
			'label' => 'Era',
			'description' => 'The Era of the item.',
			'required'=> false,
			'storeDb' => true,
		),
		'target_audience' => array(
			'property' => 'target_audience',
			'type' => 'enum',
			'values' => array(
				'' => 'Unknown',
				'Preschool (0-5)' => 'Preschool (0-5)',
				'Primary (6-8)' => 'Primary (6-8)',
				'Pre-adolescent (9-13)' => 'Pre-adolescent (9-13)',
				'Adolescent (14-17)' => 'Adolescent (14-17)',
				'Adult' => 'Adult',
				'Easy Reader' => 'Easy Reader',
				'Juvenile' => 'Juvenile',
				'General Interest' => 'General Interest',
				'Special Interest' => 'Special Interest',
			),
			'label' => 'Target Audience',
			'description' => 'The Target Audience of the item.',
			'required'=> false,
			'storeDb' => true,
		),

		'date_added' => array(
			'property' => 'date_added',
			'type' => 'hidden',
			'label' => 'Date Added',
			'description' => 'The Date Added.',
			'required'=> false,
			'storeDb' => true,
		),
		'notes' => array(
			'property' => 'notes',
			'type' => 'textarea',
			'label' => 'Notes',
			'rows'=>3,
			'cols'=>80,
			'description' => 'The Notes on the item.',
			'required'=> false,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'ilsId' => array(
			'property'=>'ilsId',
			'type'=>'text',
			'label'=>'ilsId',
			'primaryKey'=>true,
			'description'=>'The Id of the record within the ILS or blank if the record does not exist in the ILS.',
			'required' => false,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'source' => array(
			'property' => 'source',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Source',
			'description' => 'The Source of the item.',
			'required'=> true,
			'storeDb' => true,
			'storeSolr' => false,
		),

		'sourceUrl' => array(
			'property' => 'sourceUrl',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Source Url',
			'description' => 'The Source Url of the item.',
			'required'=> false,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'purchaseUrl' => array(
			'property' => 'purchaseUrl',
			'type' => 'text',
			'size' => 100,
			'maxLength'=>100,
			'label' => 'Purchase Url',
			'description' => 'The Purchase Url of the item.',
			'required'=> false,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'addedBy' => array(
				'property'=>'addedBy',
				'type'=>'hidden',
				'label'=>'addedBy',
				'description'=>'addedBy',
				'storeDb' => true,
				'storeSolr' => false
		),
		'reviewedBy' => array(
				'property'=>'reviewedBy',
				'type'=>'hidden',
				'label'=>'reviewedBy',
				'description'=>'reviewedBy',
				'storeDb' => true,
				'storeSolr' => false,
		),
		'reviewStatus' => array(
			'property' => 'reviewStatus',
			'type' => 'enum',
			'values' => array('Not Reviewed' => 'Not Reviewed', 'Approved' => 'Approved', 'Rejected' => 'Rejected'),
			'label' => 'Review Status',
			'description' => 'The Review Status of the item.',
			'required'=> true,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'reviewNotes' => array(
			'property' => 'reviewNotes',
			'type' => 'textarea',
			'label' => 'Review Notes',
			'rows'=>3,
			'cols'=>80,
			'description' => 'The Review Notes on the item.',
			'required'=> false,
			'storeDb' => true,
			'storeSolr' => false,
		),
		'keywords' => array(
			'property' => 'keywords',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'econtent_source' => array(
			'property' => 'econtent_source',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'econtent_protection_type' => array(
			'property' => 'econtent_protection_type',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'format_boost' => array(
			'property' => 'format_boost',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'language_boost' => array(
			'property' => 'language_boost',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'num_holdings' => array(
			'property' => 'num_holdings',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'available_at' => array(
			'property' => 'available_at',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'bib_suppression' => array(
			'property' => 'bib_suppression',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'rating' => array(
			'property' => 'rating',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'rating_facet' => array(
			'property' => 'rating_facet',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'allfields' => array(
			'property' => 'allfields',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'title_sort' => array(
			'property' => 'title_sort',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		'time_since_added' => array(
			'property' => 'time_since_added',
			'type' => 'method',
			'storeDb' => false,
			'storeSolr' => true,
		),
		);

		return $structure;
	}
	static function getValidAccessTypes(){
		return array('free' => 'No Usage Restrictions', 'external' => 'Externally Restricted', 'acs' => 'Adobe Content Server', 'singleUse' => 'Single use per copy');
	}
	function institution(){
		$institutions = array();
		$items = $this->getItems(false);
		foreach ($items as $item){
			$libraryId = $item->libraryId;
			if ($libraryId == -1){
				$institutions[] = "Digital Collection";
			}else{
				$library = new Library();
				$library->libraryId = $libraryId;
				if ($library->find(true)){
					$institutions[] = $library->facetLabel;
				}else{
					$institutions[] = "Unknown";
				}
			}
		}
		return $institutions;
	}
	function building(){
		$institutions = array();
		$items = $this->getItems(false);
		foreach ($items as $item){
			$libraryId = $item->libraryId;
			if ($libraryId == -1){
				$institutions["Digital Collection"] = "Digital Collection";
			}else{
				$library = new Library();
				$library->libraryId = $libraryId;
				if ($library->find(true)){
					$institutions[$library->facetLabel . ' Online'] = $library->facetLabel . ' Online';
				}else{
					$institutions["Unknown"] = "Unknown";
				}
			}
		}
		return $institutions;
	}
	function title_sort(){
		$tmpTitle = $this->title;
		//Trim off leading words
		if (preg_match('/^((?:a|an|the|el|la|"|\')\\s).*$/i', $tmpTitle, $trimGroup)) {
			$partToTrim = $trimGroup[1];
			$tmpTitle = substr($tmpTitle, strlen($partToTrim));
		}
		return $tmpTitle;
	}
	function allfields(){
		$allFields = "";
		foreach ($this as $field => $value){

			if (!in_array($field, array('__table', 'items', 'N', 'marcRecord')) && strpos($field, "_") !== 0){
				//echo ("Processing $field\r\n<br/>");
				if (is_array($value)){
					foreach ($value as $val){
						if (strlen($val) > 0){
							$allFields .= " $val";
						}
					}
				}else if (strlen($value) > 0){
					$allFields .= " $value";
				}
			}
		}
		return trim($allFields);
	}
	function rating(){
		require_once ROOT_DIR . '/sys/eContent/EContentRating.php';
		$econtentRating = new EContentRating();
		$query = "SELECT AVG(rating) as avgRating from econtent_rating where recordId = {$this->id}";
		$econtentRating->query($query);
		if ($econtentRating->N > 0){
			$econtentRating->fetch();
			if ($econtentRating->avgRating == 0){
				return -2.5;
			}else{
				return $econtentRating->avgRating;
			}

		}else{
			return -2.5;
		}

	}

	function rating_facet(){
		$rating = $this->rating();
		if ($rating > 4.5){
			return "fiveStar";
		}elseif ($rating > 3.5){
			return "fourStar";
		}elseif ($rating > 2.5){
			return "threeStar";
		}elseif ($rating > 1.5){
			return "twoStar";
		}elseif ($rating > 0.0001){
			return "oneStar";
		}else{
			return "Unrated";
		}
	}

	function available_at(){
		//Check to see if the item is checked out or if it has available holds
		if ($this->status == 'active'){
			require_once(ROOT_DIR . '/Drivers/EContentDriver.php');
			if ($this->source == 'Freegal'){
				return array('Freegal');
			}else{
				$driver = new EContentDriver();
				$holdings = $driver->getHolding($this->id);
				$statusSummary = $driver->getStatusSummary($this->id, $holdings);
				if ($statusSummary['availableCopies'] > 0){
					return $this->building();
				}else{
					return array();
				}
			}
		}else{
			return array();
		}
	}


	function econtent_source(){
		return $this->source;
	}
	function econtent_protection_type(){
		return $this->accessType;
	}
	function language_boost(){
		if ($this->status == 'active'){
			if ($this->language == 'English'){
				return 300;
			}else{
				return 0;
			}
		}else{
			return 0;
		}
	}
	function num_holdings(){
		$numHoldings = 0;
		if ($this->status == 'active'){
			if ($this->accessType == 'free'){
				$numHoldings = 25;
			}else{
				$numHoldings = $this->availableCopies;
			}
		}else{
			$numHoldings = 0;
		}
		if ($numHoldings > 1000){
			$numHoldings = 5;
		}
		return $numHoldings;
	}

	function validateCover(){
		//Setup validation return array
		$validationResults = array(
			'validatedOk' => true,
			'errors' => array(),
		);

		if ($_FILES['cover']["error"] != 0 && $_FILES['cover']["error"] != 4){
			$validationResults['errors'][] = DataObjectUtil::getFileUploadMessage($_FILES['cover']["error"], 'cover' );
		}

		//Make sure there aren't errors
		if (count($validationResults['errors']) > 0){
			$validationResults['validatedOk'] = false;
		}
		return $validationResults;
	}

	function format(){
		$formats = array();
		//Load itmes for the record
		$items = $this->getItems(false);
		foreach ($items as $item){
			if (isset($item->externalFormat)){
				$formatValue = $item->externalFormat;
			}else{
				$formatValue = translate($item->item_type);
			}
			$formats[$formatValue] = $formatValue;
		}
		return $formats;
	}

	function getFirstFormat(){
		$formats = $this->format();
		if (count($formats) == 0){
			return '';
		}else{
			return reset($formats);
		}
	}

	/**
	 * Get a list of devices that this title should work on based on format.
	 */
	function econtent_device(){
		$formats = $this->format();
		$devices = array();
		$deviceCompatibilityMap = $this->getDeviceCompatibilityMap();
		foreach ($formats as $format){
			if (array_key_exists($format, $deviceCompatibilityMap)){
				$devices = array_merge($devices, $deviceCompatibilityMap[$format]);
			}
		}
		return $devices;
	}

	/**
	 * Get a list of all formats that are in the catalog with a list of devices that support that format.
	 * Information is stored in device_compatibility_map.ini with a format per line and devices that support
	 * the format separated by line.
	 */
	function getDeviceCompatibilityMap(){
		global $memCache;
		global $configArray;
		global $serverName;
		$deviceMap = $memCache->get('device_compatibility_map');
		if ($deviceMap == false){
			$deviceMap = array();
			if (file_exists("../../sites/$serverName/conf/device_compatibility_map.ini")){
				// Return the file path (note that all ini files are in the conf/ directory)
				$deviceMapFile = "../../sites/$serverName/conf/device_compatibility_map.ini";
			}else{
				$deviceMapFile = "../../sites/default/conf/device_compatibility_map.ini";
			}
			$formatInformation = parse_ini_file($deviceMapFile);
			foreach ($formatInformation as $format => $devicesCsv){
				$devices = explode(",", $devicesCsv);
				$deviceMap[$format] = $devices;
			}
			$memCache->set('device_compatibility_map', $deviceMap, 0, $configArray['Caching']['device_compatibility_map']);
		}
		return $deviceMap;
	}

	/**
	 * Get a list of all formats that are in the catalog with a mapping to the correct category to use for the format.
	 * Information is stored in econtent_category_map.ini with a format per line and the category to use after it.
	 * Use a * to match any category
	 */
	function getFormatCategoryMap(){
		global $memCache;
		global $configArray;
		global $serverName;
		$categoryMap = $memCache->get('econtent_category_map');
		if ($categoryMap == false){
			$categoryMap = array();
			if (file_exists("../../sites/$serverName/translation_maps/format_category_map.properties")){
				// Return the file path (note that all ini files are in the conf/ directory)
				$categoryMapFile = "../../sites/$serverName/translation_maps/format_category_map.properties";
			}else{
				$categoryMapFile = "../../sites/default/translation_maps/format_category_map.properties";
			}
			$formatInformation = parse_ini_file($categoryMapFile);
			foreach ($formatInformation as $format => $category){
				$categoryMap[$format] = $category;
			}

			$memCache->set('econtent_category_map', $categoryMap, 0, $configArray['Caching']['econtent_category_map']);
		}
		return $categoryMap;
	}

	function econtentText(){
		$eContentText = "";
		//Do not index full text for now since we get many invalid characters wih certain files
		return $eContentText;
		/*if (!$this->_quickReindex && strcasecmp($this->source, 'OverDrive') != 0){
			//Load items for the record
			$items = $this->getItems();
			//Load full text of each item if possible
			foreach ($items as $item){
				$eContentText .= $item->getFullText();
			}
		}
		return $eContentText;*/
	}

	private $items = null;
	function getItems($reload = false, $allowReindex = true){
		if ($this->items == null || $reload){
			$this->items = array();

			require_once ROOT_DIR . '/sys/eContent/EContentItem.php';
			$eContentItem = new EContentItem();
			$eContentItem->recordId = $this->id;
			$eContentItem->find();
			while ($eContentItem->fetch()){
				$this->items[] = clone $eContentItem;
			}
		}
		return $this->items;
	}

	private $availability = null;
	function getAvailability(){
		global $configArray;
		if ($this->availability == null){
			$this->availability = array();
			require_once ROOT_DIR . '/sys/eContent/EContentAvailability.php';
			$eContentAvailability = new EContentAvailability();
			$eContentAvailability->recordId = $this->id;
			$eContentAvailability->find();
			while ($eContentAvailability->fetch()){
				$this->availability[] = clone $eContentAvailability;
			}
			if (strcasecmp($this->source, "OverDrive") == 0 ){
				require_once ROOT_DIR . '/Drivers/OverDriveDriverFactory.php';
				$driver = OverDriveDriverFactory::getDriver();
				//echo("Loading availability from overdrive, part of " . count($this->availability) . " collections");
				foreach ($this->availability as $key => $tmpAvailability){
					//echo("\r\n{$tmpAvailability->libraryId}");
					//Get updated availability for each library from overdrive
					$productKey = $configArray['OverDrive']['productsKey'];
					if ($tmpAvailability->libraryId != -1){
						$library = new Library();
						$library->libraryId = $tmpAvailability->libraryId;
						$library->find(true);
						$productKey = $library->overdriveAdvantageProductsKey;
					}
					$realtimeAvailability = $driver->getProductAvailability($this->externalId, $productKey);
					$tmpAvailability->copiesOwned = $realtimeAvailability->copiesOwned;
					$tmpAvailability->availableCopies = $realtimeAvailability->copiesAvailable;
					$tmpAvailability->numberOfHolds = $realtimeAvailability->numberOfHolds;
					$this->availability[$key] = $tmpAvailability;
				}
			}

			if (count($this->availability) == 0){
				//Did not get availability from the Availability table
				if ($this->itemLevelOwnership){
					//Ownership is determined at the item level based on library ids set for the item.  Assume unlimited availability
					$items = $this->getItems();
					foreach ($items as $item){
						$eContentAvailability = new EContentAvailability();
						$eContentAvailability->recordId = $this->id;
						$eContentAvailability->copiesOwned = 1;
						$eContentAvailability->availableCopies = 1;
						$eContentAvailability->numberOfHolds = 0;
						$eContentAvailability->libraryId = $item->libraryId;
						$this->availability[] = $eContentAvailability;
					}
				}else{
					//Ownership is shared, based on information at record level
					$eContentAvailability = new EContentAvailability();
					$eContentAvailability->recordId = $this->id;
					$eContentAvailability->copiesOwned = $this->availableCopies;

					$checkouts = new EContentCheckout();
					$checkouts->status = 'out';
					$checkouts->recordId = $this->id;
					$checkouts->find();
					$curCheckouts = $checkouts->N;
					if ($this->accessType == 'free'){
						$this->availableCopies = 999999;
					}
					$eContentAvailability->availableCopies = $this->availableCopies - $curCheckouts;
					$eContentAvailability->copiesOwned = $this->availableCopies;

					$holds = new EContentHold();
					$holds->whereAdd("status in ('active', 'suspended', 'available')");
					$holds->recordId = $this->id;
					$holds->find();
					$eContentAvailability->numberOfHolds = $holds->N;
					$eContentAvailability->onOrderCopies = $this->onOrderCopies;
					$eContentAvailability->libraryId = -1;
				}
			}
		}
		return $this->availability;
	}

	function getNumItems(){
		if ($this->items == null){
			$this->items = array();
			if (strcasecmp($this->source, 'OverDrive') == 0){
				return -1;
			}else{
				require_once ROOT_DIR . '/sys/eContent/EContentItem.php';
				$eContentItem = new EContentItem();
				$eContentItem->recordId = $this->id;
				$eContentItem->find();
				return $eContentItem->N;
			}
		}
		return count($this->items);
	}

	function isOverDrive(){
		return strcasecmp($this->source, 'OverDrive') == 0;
	}
	function validateEpub(){
		//Setup validation return array
		$validationResults = array(
			'validatedOk' => true,
			'errors' => array(),
		);

		//Check to see if we have an existing file
		if (isset($_REQUEST['filename_existing']) && $_FILES['filename']['error'] != 4){
			if ($_FILES['filename']["error"] != 0){
				$validationResults['errors'][] = DataObjectUtil::getFileUploadMessage($_FILES['filename']["error"], 'filename' );
			}

			//Make sure that the epub is unique, the title for the object should already be filled out.
			$query = "SELECT * FROM epub_files WHERE filename='" . mysql_escape_string($this->filename) . "' and id != '{$this->id}'";
			$result = mysql_query($query);
			if (mysql_numrows($result) > 0){
				//The title is not unique
				$validationResults['errors'][] = "This file has already been uploaded.	Please select another name.";
			}

			if ($this->type == 'epub'){
				if ($_FILES['filename']['type'] != 'application/epub+zip' && $_FILES['filename']['type'] != 'application/octet-stream'){
					$validationResults['errors'][] = "It appears that the file uploaded is not an EPUB file.	Please upload a valid EPUB without DRM.	Detected {$_FILES['filename']['type']}.";
				}
			}else if ($this->type == 'pdf'){
				if ($_FILES['filename']['type'] != 'application/pdf'){
					$validationResults['errors'][] = "It appears that the file uploaded is not a PDF file.	Please upload a valid PDF without DRM.	Detected {$_FILES['filename']['type']}.";
				}
			}
		}else{
			//Using the existing file.
		}

		//Make sure there aren't errors
		if (count($validationResults['errors']) > 0){
			$validationResults['validatedOk'] = false;
		}
		return $validationResults;
	}

	function insert(){
		//Update Solr only on insert since if we are inserting it needs to be in the index to view it again.
		$ret = parent::insert();
		if ($ret){
			$this->clearCachedCover();
		}

		return $ret;
	}

	function update(){
		//Check to see if we are adding copies.
		//If so, we wil need to process the hold queue after
		//The tile is saved
		$currentValue = new EContentRecord();
		$currentValue->id = $this->id;
		$currentValue->find(true);

		//Don't update solr, rely on the nightly reindex
		$ret = parent::update();
		if ($ret){
			$this->clearCachedCover();
			if ($currentValue->N == 1 && $currentValue->availableCopies != $this->availableCopies){
				require_once ROOT_DIR . '/Drivers/EContentDriver.php';
				$eContentDriver = new EContentDriver();
				$eContentDriver->processHoldQueue($this->id);
			}
		}
		return $ret;
	}
	private function clearCachedCover(){
		global $configArray;

		//Clear the cached bookcover if one has been added.
		global $logger;
		if (isset($this->cover) && (strlen($this->cover) > 0)){
			//Call via API since bookcovers may be on a different server
			$url = $configArray['Site']['coverUrl'] . '/API/ItemAPI?method=clearBookCoverCacheById&id=econtentRecord' . $this->id;
			$logger->log("Clearing cached cover: $url", PEAR_LOG_DEBUG );
			file_get_contents($url);
		}else{
			$logger->log("Record {$this->id} does not have cover ({$this->cover}), not clearing cache", PEAR_LOG_DEBUG );
		}
	}
	public function getPropertyArray($propertyName){
		$propertyValue = $this->$propertyName;
		if (strlen($propertyValue) == 0){
			return array();
		}else{
			return explode("\r\n", $propertyValue);
		}
	}
	public function getIsbn(){
		require_once ROOT_DIR . '/sys/ISBN.php';
		$isbns = $this->getPropertyArray('isbn');
		if (count($isbns) == 0){
			return null;
		}else{
			$isbn = ISBN::normalizeISBN($isbns[0]);
			return $isbn;
		}
	}
	public function getIsbn10(){
		require_once ROOT_DIR . '/sys/ISBN.php';
		$isbn = $this->getIsbn();
		if ($isbn == null){
			return $isbn;
		}elseif(strlen($isbn == 10)){
			return $isbn;
		}else{
			require_once ROOT_DIR . '/Drivers/marmot_inc/ISBNConverter.php';
			return ISBNConverter::convertISBN13to10($isbn);
		}
	}
	public function getUpc(){
		$upcs = $this->getPropertyArray('upc');
		if (count($upcs) == 0){
			return null;
		}else{
			return $upcs[0];
		}
	}

	public function delete(){
		//Delete any items that are associated with the record
		if (strcasecmp($this->source, 'OverDrive') != 0){
			$items = $this->getItems();
			foreach ($items as $item){
				$item->delete();
			}
		}
		parent::delete();
	}
	public function time_since_added(){
		return '';
	}
	public function getOverDriveId(){
		if ($this->externalId == null || strlen($this->externalId == 0)){
			$overdriveUrl = $this->sourceUrl;
			if ($overdriveUrl == null || strlen($overdriveUrl) < 36){
				return null;
			}else{
				if (preg_match('/([A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12})/', $overdriveUrl, $matches)) {
					$this->externalId = $matches[0];
					$this->updateDetailed(false);
				}
			}
		}
		return $this->externalId;
	}

	//setters and getters
	public function getid(){
		return $this->id;
	}

	public function setid($id){
		$this->id = $id;
	}

	public function getcover(){
		return $this->cover;
	}

	public function setcover($cover){
		$this->cover = $cover;
	}

	public function gettitle(){
		return $this->title;
	}

	public function settitle($title){
		$this->title = $title;
	}

	public function getsubtitle(){
		return $this->subtitle;
	}

	public function setsubtitle($subtitle){
		$this->subtitle = $subtitle;
	}

	public function getauthor(){
		return $this->author;
	}

	public function setauthor($author){
		$this->author = $author;
	}

	public function getauthor2(){
		return $this->author2;
	}

	public function setauthor2($author2){
		$this->author2 = $author2;
	}

	public function getdescription(){
		return $this->description;
	}

	public function setdescription($description){
		$this->description = $description;
	}

	public function getcontents(){
		return $this->contents;
	}

	public function setcontents($contents){
		$this->contents = $contents;
	}

	public function getsubject(){
		return $this->subject;
	}

	public function setsubject($subject){
		$this->subject = $subject;
	}

	public function getlanguage(){
		return $this->language;
	}

	public function setlanguage($language){
		$this->language = $language;
	}

	public function getpublisher(){
		return $this->publisher;
	}

	public function setpublisher($publisher){
		$this->publisher = $publisher;
	}

	public function getpublishdate(){
		return $this->publishdate;
	}

	public function setpublishdate($publishdate){
		$this->publishdate = $publishdate;
	}

	public function getedition(){
		return $this->edition;
	}

	public function setedition($edition){
		$this->edition = $edition;
	}

	public function getissn(){
		return $this->issn;
	}

	public function setissn($issn){
		$this->issn = $issn;
	}

	public function getlccn(){
		return $this->lccn;
	}

	public function setlccn($lccn){
		$this->lccn = $lccn;
	}

	public function getseries(){
		return $this->series;
	}

	public function setseries($series){
		$this->series = $series;
	}

	public function gettopic(){
		return $this->topic;
	}

	public function settopic($topic){
		$this->topic = $topic;
	}

	public function getgenre(){
		return $this->genre;
	}

	public function setgenre($genre){
		$this->genre = $genre;
	}

	public function getregion(){
		return $this->region;
	}

	public function setregion($region){
		$this->region = $region;
	}

	public function getera(){
		return $this->era;
	}

	public function setera($era){
		$this->era = $era;
	}

	public function gettarget_audience(){
		return $this->target_audience;
	}

	public function settarget_audience($target_audience){
		$this->target_audience = $target_audience;
	}

	public function getdate_added(){
		return $this->date_added;
	}

	public function setdate_added($date_added){
		$this->date_added = $date_added;
	}

	public function getdate_updated(){
		return $this->date_updated;
	}

	public function setdate_updated($date_updated){
		$this->date_updated = $date_updated;
	}

	public function getnotes(){
		return $this->notes;
	}

	public function setnotes($notes){
		$this->notes = $notes;
	}

	public function getilsid(){
		return $this->ilsid;
	}

	public function setilsid($ilsid){
		$this->ilsid = $ilsid;
	}

	public function getsource(){
		return $this->source;
	}

	public function setsource($source){
		$this->source = $source;
	}

	public function getsourceurl(){
		return $this->sourceurl;
	}

	public function setsourceurl($sourceurl){
		$this->sourceurl = $sourceurl;
	}

	public function getpurchaseurl(){
		return $this->purchaseurl;
	}

	public function setpurchaseurl($purchaseurl){
		$this->purchaseurl = $purchaseurl;
	}

	public function getaddedby(){
		return $this->addedby;
	}

	public function setaddedby($addedby){
		$this->addedby = $addedby;
	}

	public function getreviewedby(){
		return $this->reviewedby;
	}

	public function setreviewedby($reviewedby){
		$this->reviewedby = $reviewedby;
	}

	public function getreviewstatus(){
		return $this->reviewstatus;
	}

	public function setreviewstatus($reviewstatus){
		$this->reviewstatus = $reviewstatus;
	}

	public function getreviewnotes(){
		return $this->reviewnotes;
	}

	public function setreviewnotes($reviewnotes){
		$this->reviewnotes = $reviewnotes;
	}

	public function getaccesstype(){
		return $this->accesstype;
	}

	public function setaccesstype($accesstype){
		$this->accesstype = $accesstype;
	}

	public function getavailablecopies(){
		return $this->availablecopies;
	}

	public function setavailablecopies($availablecopies){
		$this->availablecopies = $availablecopies;
	}

	public function getonordercopies(){
		return $this->onordercopies;
	}

	public function setonordercopies($onordercopies){
		$this->onordercopies = $onordercopies;
	}

	public function gettrialtitle(){
		return $this->trialtitle;
	}

	public function settrialtitle($trialtitle){
		$this->trialtitle = $trialtitle;
	}

	public function getmarccontrolfield(){
		return $this->marccontrolfield;
	}

	public function setmarccontrolfield($marccontrolfield){
		$this->marccontrolfield = $marccontrolfield;
	}

	public function getcollection(){
		return $this->collection;
	}

	public function setcollection($collection){
		$this->collection = $collection;
	}

	public function getliterary_form_full(){
		return $this->literary_form_full;
	}

	public function setliterary_form_full($literary_form_full){
		$this->literary_form_full = $literary_form_full;
	}

	public function getstatus(){
		return $this->status;
	}

	public function setstatus($status){
		$this->status = $status;
	}
}