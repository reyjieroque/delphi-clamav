(********************************************
my interpretation of the c library clamav.h
version 0.95.3
- reyjie.u.roque@gmail.com -
--------- give me some credit if you find
--------- this usefull :D
*********************************************)
unit clamav3;
interface

uses
  Windows;

  const
    External_library='libclamav.dll'; {Setup as you need}

  Type
   { PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;  }
    uint32_t  = Cardinal;  // Integer?
    uint64_t  = LongWord;  // LongInt ?
	  cuint     = integer;
    culong    = ULONG;
    cint      = Integer;
    clonglong = int64;



  Type
  Pcli_ftype      = Pointer;
  Pcli_ignored    = Pointer;
  Pcli_matcher    = Pointer;
  Pcli_meta_node  = Pointer;
  Pmpool_t        = Pointer;
  Pphishcheck     = Pointer;
  Pregex_matcher  = Pointer;
  PStat           = Pointer;

  Const
    CL_CLEAN      = 0;
    CL_SUCCESS    = 0;
    CL_VIRUS      = 1;
    CL_ENULLARG   = 2;
    CL_EARG       = 3;
    CL_EMALFDB    = 4;
    CL_ECVD       = 5;
    CL_EVERIFY    = 6;
    CL_EUNPACK    = 7;
    CL_EUSERABORT = 8;
		CL_EOPEN      = 9;
		CL_ECREAT     = 10;
		CL_EUNLINK    = 11;
		CL_ESTAT      = 12;
		CL_EREAD      = 13;
		CL_ESEEK      = 14;
		CL_EWRITE     = 15;
		CL_EDUP       = 16;
		CL_EACCES     = 17;
		CL_ETMPFILE   = 18;
		CL_ETMPDIR    = 19;
		CL_EMAP       = 20;
		CL_EMEM       = 21;
		CL_ETIMEOUT   = 22;
		CL_BREAK      = 23;
		CL_EMAXREC    = 24;
		CL_EMAXSIZE   = 25;
		CL_EMAXFILES  = 26;
		CL_EFORMAT    = 27;


{	type
		cl_error_t = (
			CL_CLEAN = 0,
       			CL_SUCCESS = 0,
       			CL_VIRUS,
       			CL_ENULLARG,
       			CL_EARG,
       			CL_EMALFDB,
       			CL_ECVD,
       			CL_EVERIFY,
       			CL_EUNPACK,
       			CL_EUSERABORT,
       			CL_EOPEN,
       			CL_ECREAT,
       			CL_EUNLINK,
       			CL_ESTAT,
       			CL_EREAD,
       			CL_ESEEK,
       			CL_EWRITE,
       			CL_EDUP,
       			CL_EACCES,
       			CL_ETMPFILE,
       			CL_ETMPDIR,
       			CL_EMAP,
       			CL_EMEM,
       			CL_ETIMEOUT,
       			CL_BREAK,
       			CL_EMAXREC,
       			CL_EMAXSIZE,
       			CL_EMAXFILES,
       			CL_EFORMAT);
		Pcl_error_t  = ^cl_error_t;
 }
  const
     CL_COUNT_PRECISION = 4096;
     CL_DB_PHISHING = $2;
     CL_DB_PHISHING_URLS = $8;
     CL_DB_PUA = $10;     
     CL_DB_CVDNOTMP = $20;     

     CL_DB_OFFICIAL = $40;     
     CL_DB_PUA_MODE = $80;     
     CL_DB_PUA_INCLUDE = $100;     
     CL_DB_PUA_EXCLUDE = $200;     

     CL_DB_COMPILED = $400;     

     CL_DB_DIRECTORY = $800;     

     CL_DB_STDOPT = CL_DB_PHISHING or CL_DB_PHISHING_URLS;     

     CL_SCAN_RAW = $0;
     CL_SCAN_ARCHIVE = $1;
     CL_SCAN_MAIL = $2;     
     CL_SCAN_OLE2 = $4;
     CL_SCAN_BLOCKENCRYPTED = $8;
     CL_SCAN_HTML = $10;     
     CL_SCAN_PE = $20;     
     CL_SCAN_BLOCKBROKEN = $40;     
     CL_SCAN_MAILURL = $80;     

     CL_SCAN_BLOCKMAX = $100;     
     CL_SCAN_ALGORITHMIC = $200;

     CL_SCAN_PHISHING_BLOCKSSL = $800;     
     CL_SCAN_PHISHING_BLOCKCLOAK = $1000;     
     CL_SCAN_ELF = $2000;     
     CL_SCAN_PDF = $4000;
     CL_SCAN_STRUCTURED = $8000;     
     CL_SCAN_STRUCTURED_SSN_NORMAL = $10000;
     CL_SCAN_STRUCTURED_SSN_STRIPPED = $20000;     
     CL_SCAN_PARTIAL_MESSAGE = $40000;
     CL_SCAN_HEURISTIC_PRECEDENCE = $80000;     

     CL_SCAN_STDOPT = ((((((CL_SCAN_ARCHIVE or CL_SCAN_MAIL) or CL_SCAN_OLE2) or CL_SCAN_PDF) or CL_SCAN_HTML) or CL_SCAN_PE) or CL_SCAN_ALGORITHMIC) or CL_SCAN_ELF;     

  type

	cli_dconf = record
    		pe	:uint32_t;
    		elf	:uint32_t;
    		archive	:uint32_t;
    		doc	:uint32_t;
    		mail	:uint32_t;
    		other	:uint32_t;
    		phishing:uint32_t;
	end;
  Pcli_dconf  = ^cli_dconf;


     Pcl_engine = ^cl_engine;
     cl_engine = record
          refcount 	: uint32_t;
          sdb 		: uint32_t;
          dboptions 	: uint32_t;
          dbversion 	: array[0..1] of uint32_t;
          ac_only 	: uint32_t;
          ac_mindepth 	: uint32_t;
          ac_maxdepth 	: uint32_t;
          tmpdir 	: PChar;
          keeptmp 	: uint32_t;
          maxscansize 	: uint64_t;
          maxfilesize 	: uint64_t;
          maxreclevel 	: uint32_t;
          maxfiles 	: uint32_t;
          min_cc_count 	: uint32_t;
          min_ssn_count : uint32_t;
          root 		: Pointer;
          md5_hdb 	: Pcli_matcher;
          md5_mdb 	: Pcli_matcher;
          md5_fp 	: Pcli_matcher;
          zip_mlist 	: Pcli_meta_node;
          rar_mlist	: Pcli_meta_node;
          whitelist_matcher : Pregex_matcher;
          domainlist_matcher : Pregex_matcher;
          phishcheck 	: Pphishcheck;
          dconf 	: Pcli_dconf;
          ftypes 	: Pcli_ftype;
          ignored 	: Pcli_ignored;
          pua_cats 	: PChar;
          mempool : Pmpool_t;
          callback : function (desc:cint; bytes:cint):cint;cdecl;
       end;
       {$EXTERNALSYM cl_engine}


     Pcl_settings = ^cl_settings;
     cl_settings = record
          ac_only : uint32_t;
          ac_mindepth : uint32_t;
          ac_maxdepth : uint32_t;
          tmpdir : pchar;
          keeptmp : uint32_t;
          maxscansize : uint64_t;
          maxfilesize : uint64_t;
          maxreclevel : uint32_t;
          maxfiles : uint32_t;
          min_cc_count : uint32_t;
          min_ssn_count : uint32_t;
          pua_cats : pchar;
       end;


  const
     CL_INIT_DEFAULT = $0;     

  function cl_init(initoptions:cuint):cint;cdecl;external External_library name 'cl_init';

  function cl_engine_new:Pcl_engine;cdecl;external External_library name 'cl_engine_new';

  type
	cl_engine_field = (
       		CL_ENGINE_MAX_SCANSIZE,
       		CL_ENGINE_MAX_FILESIZE,
       		CL_ENGINE_MAX_RECURSION,
       		CL_ENGINE_MAX_FILES,
       		CL_ENGINE_MIN_CC_COUNT,
       		CL_ENGINE_MIN_SSN_COUNT,
       		CL_ENGINE_PUA_CATEGORIES,
       		CL_ENGINE_DB_OPTIONS,
       		CL_ENGINE_DB_VERSION,
       		CL_ENGINE_DB_TIME,
       		CL_ENGINE_AC_ONLY,
       		CL_ENGINE_AC_MINDEPTH,
       		CL_ENGINE_AC_MAXDEPTH,
       		CL_ENGINE_TMPDIR,
       		CL_ENGINE_KEEPTMP);
	Pcl_engine_field  = ^cl_engine_field;
	


  function cl_engine_set_num(var engine:cl_engine; field:cl_engine_field; num:clonglong):cint;cdecl;external External_library name 'cl_engine_set_num';

  function cl_engine_get_num(var engine:cl_engine; field:cl_engine_field; var err:cint):clonglong;cdecl;external External_library name 'cl_engine_get_num';

  function cl_engine_set_str(var engine:cl_engine; field:cl_engine_field; str:PChar):cint;cdecl;external External_library name 'cl_engine_set_str';

  function cl_engine_get_str(var engine:cl_engine; field:cl_engine_field; var err:cint):PChar;cdecl;external External_library name 'cl_engine_get_str';

  function cl_engine_settings_copy(var engine:cl_engine):Pcl_settings;cdecl;external External_library name 'cl_engine_settings_copy';

  function cl_engine_settings_apply(var engine:cl_engine; var settings:cl_settings):cint;cdecl;external External_library name 'cl_engine_settings_apply';

  function cl_engine_settings_free(var settings:cl_settings):cint;cdecl;external External_library name 'cl_engine_settings_free';

  function cl_engine_compile(var engine:cl_engine):cint;cdecl;external External_library name 'cl_engine_compile';

  function cl_engine_addref(var engine:cl_engine):cint;cdecl;external External_library name 'cl_engine_addref';

//  function cl_engine_setcallback(var engine:cl_engine; callback:function (desc:cint; bytes:cint):cint):cint;cdecl;external External_library name 'cl_engine_setcallback';

  function cl_engine_free(var engine:cl_engine):cint;cdecl;external External_library name 'cl_engine_free';


  type
     cl_stat = record
          dir : PChar;
          stattab : Pstat;
          statdname : ^PChar;
          entries : cuint;
       end;
	Pcl_stat = ^cl_stat;


     cl_cvd = record
          time : PChar;
          version : cuint;
          sigs : cuint;
          fl : cuint;
          md5 : PChar;
          dsig : PChar;
          builder : PChar;
          stime : cuint;
       end;
	Pcl_cvd = ^cl_cvd;

(* File Scanning*)
  function cl_scandesc(desc:cint; virname:PChar; var scanned:culong; var engine:cl_engine; scanoptions:cuint):cint;cdecl;external External_library name 'cl_scandesc';
  function cl_scanfile(filename:PChar; virname:PChar; var scanned:culong; var engine:cl_engine; scanoptions:cuint):cint;cdecl;external External_library name 'cl_scanfile';

(* Database Handling*)
  function cl_load(path:PChar; var engine:cl_engine; var signo:cuint; dboptions:cuint):cint;cdecl;external External_library name 'cl_load';
  function cl_retdbdir:PChar;cdecl;external External_library name 'cl_retdbdir';

(*Engine Handling*)
// CVD //
  function cl_cvdhead(filename:PChar):Pcl_cvd;cdecl;external External_library name 'cl_cvdhead';
  function cl_cvdparse(head:PChar):Pcl_cvd;cdecl;external External_library name 'cl_cvdparse';
  function cl_cvdverify(filename:PChar):cint;cdecl;external External_library name 'cl_cvdverify';
  procedure cl_cvdfree(var cvd:cl_cvd);cdecl;external External_library name 'cl_cvdfree';
// db dir stat function //
  function cl_statinidir(dirname:PChar; var dbstat:cl_stat):cint;cdecl;external External_library name 'cl_statinidir';
  function cl_statchkdir(var dbstat:cl_stat):cint;cdecl;external External_library name 'cl_statchkdir';
  function cl_statfree(var dbstat:cl_stat):cint;cdecl;external External_library name 'cl_statfree';
// enable debug message //
  procedure cl_debug;cdecl;external External_library name 'cl_debug';
// Software versions //
  function cl_retflevel:cuint;cdecl;external External_library name 'cl_retflevel';
  function cl_retver:PChar;cdecl;external External_library name 'cl_retver';
// others //
  function cli_gettempdir:PChar;cdecl;external External_library name 'cli_gettempdir';
  function cli_rmdirs(dirname:PChar):cint;cdecl;external External_library name 'cli_rmdirs';
  function cl_strerror(clerror:cint):PChar;cdecl;external External_library name 'cl_strerror';

  Function IsClamAVLibPresent: Boolean;
  function OpenLongFileName(const ALongFileName:String;
                                SharingMode: DWORD): THandle;

implementation
uses sysutils;

Function IsClamAVLibPresent;
begin
  Result := FileExists(External_library);
end;

function OpenLongFileName(const ALongFileName:String;
                                SharingMode: DWORD): THandle;
begin
  if CompareMem(@(ALongFileName[1]), @('\\'[1]), 2) then
    { Allready an UNC path }
    Result := CreateFileW(PWideChar(WideString(ALongFileName)), GENERIC_READ, SharingMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
  else
    Result := CreateFileW(PWideChar(WideString('\\?\' + ALongFileName)), GENERIC_READ, SharingMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
end;

end.

