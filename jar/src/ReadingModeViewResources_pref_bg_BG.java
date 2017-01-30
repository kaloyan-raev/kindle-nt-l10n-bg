package com.amazon.ebook.booklet.reader.gui.view.pagecontentview.resources;

import java.util.ListResourceBundle;
import java.util.*;
import java.io.*;

public class ReadingModeViewResources_bg_BG extends ListResourceBundle
{
    private static final String PREFS_FILE = "/mnt/us/system/fontfix.pref";
    private static final String EXCEPTION_FILE = "/mnt/us/system/fontfix.log";
    private static final String MOBI_TMARGIN_DEFAULT = "20";

    private static String _mobiTMargin = MOBI_TMARGIN_DEFAULT;
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
            _mobiTMargin = p.getProperty("MOBI_TOP_MARGIN", MOBI_TMARGIN_DEFAULT);
            int MTM_value;
            try
            {
                MTM_value = Integer.parseInt(_mobiTMargin);
            }
            catch (NumberFormatException nfe)
            {
                throw new Exception("MOBI_TOP_MARGIN should be one integer value - e.g. 20.");
            }
            if (MTM_value <= -1 || MTM_value >= 31)
                throw new Exception("MOBI_TOP_MARGIN value must be from 0 to 30.");
        }
        catch (Throwable e)
        {
            dumpException(e);
            _mobiTMargin = MOBI_TMARGIN_DEFAULT;
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

    public ReadingModeViewResources_bg_BG()
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
                "header.height", new Integer(_mobiTMargin)
            }, new Object[] {
                "progress.bar.reserved.spacing", new Integer(38)
            }
        });
    }
}
