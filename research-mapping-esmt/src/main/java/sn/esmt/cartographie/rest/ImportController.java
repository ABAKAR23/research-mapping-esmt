package sn.esmt.cartographie.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import sn.esmt.cartographie.service.CsvImportService;

@Controller
public class ImportController {

    @Autowired
    private CsvImportService csvImportService;

    @GetMapping("/import")
    public String showImportPage() {
        return "import"; // returns import.jsp
    }

    @PostMapping("/import-csv")
    public String handleFileUpload(@RequestParam("file") MultipartFile file, Model model) {
        String result = csvImportService.importProjectsFromCsv(file);

        if (result.startsWith("Importation terminée")) {
            model.addAttribute("message", result);
            model.addAttribute("messageType", "success");
        } else {
            model.addAttribute("message", result);
            model.addAttribute("messageType", "danger");
        }

        return "import";
    }
}
