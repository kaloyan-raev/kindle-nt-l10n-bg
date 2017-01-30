package com.amazon.ebook.booklet.reader.gui.view.pagecontentview.resources;

import java.util.ListResourceBundle;
import java.util.*;
import java.io.*;

public class FullScreenReadingViewResources_bg_BG extends ListResourceBundle
{
    private static final String PREFS_FILE = "/mnt/us/system/fontfix.pref";
    private static final String EXCEPTION_FILE = "/mnt/us/system/fontfix.log";
    private static final String PDF_TMARGIN_DEFAULT = "0";
    private static final String PDF_HMARGINS_DEFAULT = "0";

    private static String _pdfTMargin = PDF_TMARGIN_DEFAULT;
    private static String _pdfHMargins = PDF_HMARGINS_DEFAULT;
    private static Object _result[][];

    private static void dumpException(Throwable ex)
    {
        try
        {
            FileWriter fw = new FileWriter(EXCEPTION_FILE, true);
            PrintWriter pw = new PrintWriter(fw);
            ex.printStackTrace(pw);
            fw.close();
        }
        catch (Throwable e) { }
    }

    private static void readConfig()
    {
        FileInputStream fis = null;
        try
        {
            File prefs = new File(PREFS_FILE);
            if (!prefs.exists())
                return;
            fis = new FileInputStream(PREFS_FILE);
            Properties p = new Properties();
            p.load(fis);
            _pdfTMargin = p.getProperty("PDF_TOP_MARGIN", PDF_TMARGIN_DEFAULT);
            int PTM_value;
            try
            {
                PTM_value = Integer.parseInt(_pdfTMargin);
            }
            catch (NumberFormatException nfe)
            {
                throw new Exception("PDF_TOP_MARGIN should be one integer value - e.g. 20.");
            }
            if (PTM_value <= -1 || PTM_value >= 21)
                throw new Exception("PDF_TOP_MARGIN value must be from 0 to 20.");
        }
        catch (Throwable e)
        {
            dumpException(e);
            _pdfTMargin = PDF_TMARGIN_DEFAULT;
        }
        try
        {
            File prefs = new File(PREFS_FILE);
            if (!prefs.exists())
                return;
            fis = new FileInputStream(PREFS_FILE);
            Properties p1 = new Properties();
            p1.load(fis);
            _pdfHMargins = p1.getProperty("PDF_HORIZONTAL_MARGINS", PDF_HMARGINS_DEFAULT);
            int PHM_value;
            try
            {
                PHM_value = Integer.parseInt(_pdfHMargins);
            }
            catch (NumberFormatException nfe1)
            {
                throw new Exception("PDF_HORIZONTAL_MARGINS should be one integer value - e.g. 20.");
            }
            if (PHM_value <= -1 || PHM_value >= 21)
                throw new Exception("PDF_HORIZONTAL_MARGINS value must be from 0 to 20.");
        }
        catch (Throwable e1)
        {
            dumpException(e1);
            _pdfHMargins = PDF_HMARGINS_DEFAULT;
        }
        try
        {
            if (fis != null)
                fis.close();
        }
        catch (Throwable ex)
        {
            dumpException(ex);
        }
    }

    public FullScreenReadingViewResources_bg_BG()
    {
    }

    public Object[][] getContents()
    {
        return _result;
    }

    static 
    {
        readConfig();
        _result = (new Object[][] {
            new Object[] {
                "long.edge.margin", new Integer(_pdfTMargin)
            }, new Object[] {
                "short.edge.margin", new Integer(_pdfHMargins)
            }, new Object[] {
                "progress.bar.reserved.spacing", new Integer(38)
            }
        });
    }
}
