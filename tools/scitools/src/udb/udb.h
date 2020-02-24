/*
 *          Copyright (c) 1998-2013, Scientific Toolworks, Inc.
 *
 * This file contains proprietary information of Scientific Toolworks, Inc.
 * and is protected by federal copyright law. It may not be copied or
 * distributed in any form or medium without prior written authorization
 * from Scientific Toolworks, Inc.
 *
 */


#ifndef UDB_H_
#define UDB_H_


/*
 * public types
 */

typedef int UdbKind;
typedef struct UdbEntity_    *UdbEntity;
typedef struct UdbKindList_  *UdbKindList;
typedef struct UdbLexeme_    *UdbLexeme;
typedef struct UdbLexer_     *UdbLexer;
typedef struct UdbLibrary_   *UdbLibrary;
typedef struct UdbMetric_    *UdbMetric;
typedef struct UdbReference_ *UdbReference;



/*
 * public enumerations
 */

typedef enum UdbCommentStyle_ {
  Udb_commentStyleDefault = 0,
  Udb_commentStyleAfter   = 1,
  Udb_commentStyleBefore  = 2
} UdbCommentStyle;

typedef enum UdbCommentFormat_ {
  Udb_commentFormatDefault = 0
} UdbCommentFormat;

typedef enum UdbLanguage_ {
  Udb_language_NONE    = 0x0000,
  Udb_language_ALL     = 0x7FFF,
  Udb_language_Ada     = 0x0001,
  Udb_language_Asm     = 0x0002,
  Udb_language_Basic   = 0x0004,
  Udb_language_C       = 0x0008,
  Udb_language_Cobol   = 0x0010,
  Udb_language_CSharp  = 0x0020,
  Udb_language_Fortran = 0x0040,
  Udb_language_Java    = 0x0080,
  Udb_language_Jovial  = 0x0100,
  Udb_language_Pascal  = 0x0200,
  Udb_language_Plm     = 0x0400,
  Udb_language_Python  = 0x0800,
  Udb_language_Verilog = 0x1000,
  Udb_language_Vhdl    = 0x2000,
  Udb_language_Web     = 0x4000,
} UdbLanguage;

typedef enum UdbMetricKind_ {
  Udb_mkind_NONE=0,
  Udb_mkind_Integer,
  Udb_mkind_Real
} UdbMetricKind;


typedef enum UdbStatus_ {
  Udb_statusOkay                     = 0,
  Udb_statusDBAlreadyOpen            = 1,
  Udb_statusDBBusy                   = 2, /* not used */
  Udb_statusDBChanged                = 3,
  Udb_statusDBCorrupt                = 4,
  Udb_statusDBOldVersion             = 5,
  Udb_statusDBUnknownVersion         = 6,
  Udb_statusDBUnableCreate           = 7,
  Udb_statusDBUnableDelete           = 8,
  Udb_statusDBUnableModify           = 9,
  Udb_statusDBUnableOpen             = 10,
  Udb_statusDBUnableWrite            = 11,
  Udb_statusDemoAnotherDBOpen        = 12,
  Udb_statusDemoInvalid              = 13,
  Udb_statusDrawNoFont               = 14,
  Udb_statusDrawNoImage              = 15,
  Udb_statusDrawTooBig               = 16,
  Udb_statusDrawUnableCreateFile     = 17,
  Udb_statusDrawUnsupportedFile      = 18,
  Udb_statusLexerFileModified        = 19,
  Udb_statusLexerFileUnreadable      = 20,
  Udb_statusLexerUnsupportedLanguage = 21,
  Udb_statusNoApiLicense             = 22,
  Udb_statusNoApiLicenseAda          = 23,
  Udb_statusNoApiLicenseC            = 24,
  Udb_statusNoApiLicenseCobol        = 25,
  Udb_statusNoApiLicenseFtn          = 26,
  Udb_statusNoApiLicenseJava         = 27,
  Udb_statusNoApiLicenseJovial       = 28,
  Udb_statusNoApiLicensePascal       = 29,
  Udb_statusNoApiLicensePlm          = 30,
  Udb_statusNoApiLicensePython       = 31,
  Udb_statusNoApiLicenseWeb          = 32,
  Udb_statusNoApiLicenseVhdl         = 33,
  Udb_statusNoApiLicenseVerilog      = 34,
  Udb_statusReportUnableCreate       = 35,
  Udb_statusReportUnableDelete       = 36,
  Udb_statusReportUnableWrite        = 37,
  Udb_statusUserAbort                = 38,
  Udb_statusWrongProduct             = 39,
  Udb_status_LAST
} UdbStatus;


typedef enum UdbToken_ {
  Udb_tokenEOF            = 0,
  Udb_tokenComment        = 1,
  Udb_tokenContinuation   = 2,
  Udb_tokenDedent         = 3,
  Udb_tokenEndOfStatement = 4,
  Udb_tokenIdentifier     = 5,
  Udb_tokenIndent         = 6,
  Udb_tokenKeyword        = 7,
  Udb_tokenLabel          = 8,
  Udb_tokenLiteral        = 9,
  Udb_tokenNewline        = 10,
  Udb_tokenOperator       = 11,
  Udb_tokenPreprocessor   = 12,
  Udb_tokenPunctuation    = 13,
  Udb_tokenString         = 14,
  Udb_tokenWhitespace     = 15,
  Udb_token_LAST
} UdbToken;



/*
 * public functions
 */

#ifdef __cplusplus
extern "C" {
#endif


#if defined (_WIN32) && defined (UDB_API)
#define Export __declspec(dllexport)
#else
#define Export extern
#endif

Export char *udbComment(UdbEntity,UdbCommentStyle,UdbCommentFormat,UdbKindList);
Export void udbCommentRaw(UdbEntity,UdbCommentStyle,UdbKindList,char ***,int *);

Export void udbDbClose();

// Return the major language or languages of the current database.
Export UdbLanguage udbDbLanguage();

// Return the list of languages required to open a db. No api license is
// required for this call. Filename is in UTF-8.
Export UdbLanguage udbDbLanguages(const char *filename);

// Return the name (non-allocated) of the current database. Name is in absolute,
// real-case format. Return 0 if no database is open. Name is in UTF-8.
Export const char *udbDbName();

// Open a database. Filename is in UTF-8.
Export UdbStatus udbDbOpen(const char *filename);

Export int           udbEntityId(UdbEntity);
Export UdbKind       udbEntityKind(UdbEntity);
Export UdbLanguage   udbEntityLanguage(UdbEntity);
Export UdbLibrary    udbEntityLibrary(UdbEntity);
Export char         *udbEntityNameLong(UdbEntity);
Export char         *udbEntityNameAbsolute(UdbEntity);
Export char         *udbEntityNameRelative(UdbEntity);
Export char         *udbEntityNameShort(UdbEntity);
Export char         *udbEntityNameSimple(UdbEntity);
Export char         *udbEntityNameUnique(UdbEntity);
Export int           udbEntityParameters(UdbEntity,char **text,int shownames);
Export int           udbEntityRefs(UdbEntity,char *,char *,int,UdbReference **);
Export char         *udbEntityTypetext(UdbEntity);
Export char         *udbEntityValue(UdbEntity);
Export char         *udbEntityFreetext(UdbEntity,const char *);

Export const char   *udbInfoBuild();

Export int           udbIsKind(UdbKind,char *);
Export int           udbIsKindFile(UdbKind);

Export UdbKind       udbKindInverse(UdbKind);
Export void          udbKindList(UdbKind,UdbKindList *);
Export UdbLanguage   udbKindLanguage(UdbKind);
Export UdbKindList   udbKindListCopy(UdbKindList);
Export void          udbKindListFree(UdbKindList);
Export int           udbKindLocate(UdbKind,UdbKindList);
Export char         *udbKindLongname(UdbKind);
Export UdbKindList   udbKindParse(const char *);
Export char         *udbKindShortname(UdbKind);

// Return an array of text representations for a single or multiple language.
// An entity has a single language but a database may have multiple
// languagaes. The returned array is 0 terminated and must be freed with
// udbLanguageStringsFree().
Export char **udbLanguageStrings(UdbLanguage language);

// Free array of languages returned by udbLanguageAsStrings().
Export void udbLanguageStringsFree(char **list);

Export int           udbLexemeColumnBegin(UdbLexeme);
Export int           udbLexemeColumnEnd(UdbLexeme);
Export UdbEntity     udbLexemeEntity(UdbLexeme);
Export int           udbLexemeInactive(UdbLexeme);
Export int           udbLexemeLineBegin(UdbLexeme);
Export int           udbLexemeLineEnd(UdbLexeme);
Export UdbLexeme     udbLexemeNext(UdbLexeme);
Export UdbLexeme     udbLexemePrevious(UdbLexeme);
Export UdbReference  udbLexemeReference(UdbLexeme);
Export char         *udbLexemeText(UdbLexeme);
Export UdbToken      udbLexemeToken(UdbLexeme);

Export void          udbLexerDelete(UdbLexer);
Export UdbLexeme     udbLexerFirst(UdbLexer);
Export UdbLexeme     udbLexerLexeme(UdbLexer,int line,int col);
Export int           udbLexerLexemes(UdbLexer,int,int,UdbLexeme **);
Export int           udbLexerLines(UdbLexer);
Export UdbStatus     udbLexerNew(UdbEntity,int,UdbLexer *);

Export int           udbLibraryCheckEntity(UdbEntity,UdbLibrary *);
Export int           udbLibraryCompare(UdbLibrary,UdbLibrary);
Export void          udbLibraryFilterEntity(UdbEntity *,char *,UdbEntity **,int *);
Export void          udbLibraryList(char *,UdbLibrary **,int *);
Export void          udbLibraryListFree(UdbLibrary *);
Export char         *udbLibraryName(UdbLibrary);

Export void          udbListEntity(UdbEntity **,int *);
Export void          udbListEntityFilter(UdbEntity *,UdbKindList,UdbEntity **,int *);
Export void          udbListEntityFree(UdbEntity *);
Export void          udbListFile(UdbEntity **,int *);
Export void          udbListKindEntity(UdbKind **,int *);
Export void          udbListKindFree(UdbKind *);
Export void          udbListKindReference(UdbKind **,int *);
Export void          udbListReference(UdbEntity,UdbReference **,int *);
Export void          udbListReferenceFile(UdbEntity,UdbReference **,int *);
Export void          udbListReferenceFilter(UdbReference *,UdbKindList,UdbKindList,int,UdbReference **,int *);
Export void          udbListReferenceFree(UdbReference *);

Export void          udbLookupEntity(char *name,char *kind,int shortname,UdbEntity **,int *);
Export UdbEntity     udbLookupEntityByReference(UdbEntity,char *,int line,int col,int *matchline);
Export UdbEntity     udbLookupEntityByUniquename(char *);
Export UdbEntity     udbLookupFile(char *);

// Lookup the expansion text for a macro name at a location identified by file,
// line and column. Return true if found, or false if not. Return a temporary
// copy of the expansion text. This is only available for C++ files with the
// option "Save macro expansion text" enabled.
Export int udbLookupMacroExpansionText(const char *name,UdbEntity file,int line,int column,char **text);

// Return true if the specified entity has any reference of the general kind
// specified by the list of references. Return true if the list is 0. Kindlist
// must be allocated and will be deleted.
Export int udbLookupReferenceExists(UdbEntity,UdbKindList kindlist);

// Return the description of the specified metric, as a temporary string.
Export char *udbMetricDescription(UdbMetric);

// Return the descriptive name of the specified metric, as a temporary string.
Export char *udbMetricDescriptiveName(UdbMetric);

// Return true if the specified metric is defined for the specified entity.
Export int udbMetricIsDefinedEntity(UdbMetric,UdbEntity);

// Return true if the specified metric is defined as a project metric for the
// specified language.
Export int udbMetricIsDefinedProject(UdbMetric,UdbLanguage);

// Return the value kind of a metric.
Export UdbMetricKind udbMetricKind(UdbMetric);

// Return the size of a temporary, null-terminated list of all metrics defined
// for the specified entity.
Export int udbMetricListEntity(UdbEntity,UdbMetric **);

// Return the size of a temporary, null-terminated list of all metrics defined
// for the specified ent kinds filter.
Export int udbMetricListKind(const char *,UdbMetric **);

// Return the size of a temporary, null-terminated list of all metrics defined
// for the specified language.
Export int udbMetricListLanguage(UdbLanguage,UdbMetric **);

// Return the size of a temporary, null-terminated list of all project metrics
// defined for the specified language.
Export int udbMetricListProject(UdbLanguage,UdbMetric **);

// Lookup a metric by name.
Export UdbMetric udbMetricLookup(const char *);

// Return the name of the specified metric, as a temporary string.
Export char *udbMetricName(UdbMetric);

// Return the value of a metric for the specified entity.
Export double udbMetricValue(UdbEntity,UdbMetric);

// Return the value of a project metric.
Export double udbMetricValueProject(UdbMetric);

Export int           udbReferenceColumn(UdbReference);
Export UdbReference  udbReferenceCopy(UdbReference);
Export void          udbReferenceCopyFree(UdbReference);
Export UdbEntity     udbReferenceEntity(UdbReference);
Export UdbEntity     udbReferenceFile(UdbReference);
Export UdbKind       udbReferenceKind(UdbReference);
Export int           udbReferenceLine(UdbReference);
Export UdbEntity     udbReferenceScope(UdbReference);

Export void          udbSetLicense(char *dir);

Export const char *udbStatusText(UdbStatus status);
Export const char *udbTokenName(UdbToken token);


#undef Export

#ifdef __cplusplus
}
#endif


#endif
